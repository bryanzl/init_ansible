lst='bsmongo-c1 bsmongo-c2 bsmongo-c3 bsmongo-d1 bsmongo-d2 bsmongo-d3 bsmongo-s'

for x in $lst; do

    pushd .

    cd $x

    docker-compose up -d

    popd

done