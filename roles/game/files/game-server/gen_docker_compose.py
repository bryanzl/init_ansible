import sys
import os
import logging
import pprint
from string import Template
import yaml


def get_my_ip():
    import netifaces
    ifname = netifaces.gateways()['default'][netifaces.AF_INET][1]
    ip = netifaces.ifaddresses(ifname)[netifaces.AF_INET][0]["addr"]
    return ip


head_templ = '''
version: '2'

services:
'''

mongos_templ = '''
  bsmongo:
    container_name: bsmongo
    image: mongo:${MONGO_VER}
    restart: always
    command: mongos --bind_ip_all --port=27017 --configdb=${MONGO_CONFIGDB}
    volumes:
      - /etc/hosts:/etc/hosts
    ports:
      - '127.0.0.1:27017:27017'
'''

gs_templ = '''
  gs${SERVER_ID}:
    container_name: gs${SERVER_ID}
    hostname: gs${SERVER_ID}
    image: ${DOCKER_REGISTRY}/gs/game_server:v5
    restart: always
    ports:
      - '${SSH_PORT}:22'
      - '${GAME_PORT}:1000'
      - '${GM_PORT}:1002'
      - '${PAY_PORT}:1002'
      - '${ZRPC_PORT}:${ZRPC_PORT}'
    ulimits:
      core: -1
      memlock:
        soft: -1
        hard: -1
      nofile:
        soft: 65536
        hard: 65536
      nproc:
        soft: 8192
        hard: 8192
    volumes:
      - gs${SERVER_ID}:/game
      - /etc/hosts:/etc/hosts
'''

vol_head_templ = '''
volumes:
'''

vol_templ = '''
  gs${SERVER_ID}:
    driver: local
  mongo-data:
    driver: local
'''


def find_my_host(game_hosts, my_ip):
    for host in game_hosts:
        if host['in_ip'] == my_ip or host['ip'] == my_ip:
            return host
    return None


def make_docker_compose(host):
    ctx = []

    ctx.append(head_templ)
    MONGO_VER = os.environ['MONGO_VER']
    MONGO_CONFIGDB = os.environ['MONGO_CONFIGDB']
    ctx.append(Template(mongos_templ).substitute(
        {'MONGO_CONFIGDB': MONGO_CONFIGDB, 'MONGO_VER': MONGO_VER}))

    docker_registry = os.environ['DOCKER_REGISTRY']

    gs_t = Template(gs_templ)
    if 'servers' in host:
        for seq, gs in enumerate(host['servers']):
            server_id = gs['id']
            game_port = 1001 + seq
            ssh_port = 2001 + seq
            gm_port = 3001 + seq
            pay_port = 4001 + seq
            zrpc_port = 5001 + seq
            ctx.append(gs_t.substitute({
                'DOCKER_REGISTRY': docker_registry,
                'SERVER_ID': server_id,
                'GAME_PORT': game_port,
                'SSH_PORT': ssh_port,
                'GM_PORT': gm_port,
                'PAY_PORT': pay_port,
                'ZRPC_PORT': zrpc_port,
            }))
        ctx.append(vol_head_templ)

    vol_t = Template(vol_templ)
    if 'servers' in host:
        for gs in host['servers']:
            server_id = gs['id']
            logging.info('make docker-compose config for : %s', server_id)
            ctx.append(vol_t.substitute({'SERVER_ID': server_id}))

    return ''.join(ctx)


def ensure_dir(parent_dir, host_id):
    d = os.path.join(parent_dir, 'gs')
    if not os.path.exists(d):
        os.makedirs(d)
    return d


def main():
    logging.basicConfig(stream=sys.stdout, level=logging.DEBUG)

    rootdir = os.path.abspath(os.path.dirname(os.path.realpath(__file__)))

    my_ip = get_my_ip()
    logging.info('my ip is: %s', my_ip)

    mopath = os.path.abspath(os.path.join(
        rootdir, '..', '..', 'lib', 'python'))
    sys.path.insert(0, mopath)

    path_cfg_hosts = os.path.join(rootdir, 'config/', 'hosts.yml')

    import hosts_util
    game_hosts = hosts_util.load_hosts(path_cfg_hosts, '@gs')

    host = find_my_host(game_hosts, my_ip)
    if host:
        logging.info('my host info: %s', host)
        host_id = host['id']
        content = make_docker_compose(host)
        d = ensure_dir(rootdir, host_id)
        outfile = d + '/docker-compose.yml'
        logging.info("write result to `%s'", outfile)
        with open(outfile, 'w') as f:
            f.write(content)


main()
