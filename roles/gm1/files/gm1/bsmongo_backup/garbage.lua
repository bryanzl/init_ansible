local MINUTE = 60
local HOUR = MINUTE * 60
local DAY = HOUR * 24
local TS_TOLERANT = 3 * MINUTE


local backupIntervalConfig = {
    { 12 * HOUR, 15 * MINUTE },
    { 24 * HOUR, 30 * MINUTE },
    { 3 * DAY, 2 * HOUR },
    { 7 * DAY, 4 * HOUR },
    { 14 * DAY, 8 * HOUR },
    { 30 * DAY, 24 * HOUR },
    { 1000 * DAY, 7 * DAY },
}


function selectConfig(item)
    local now = os.time()
    local ts = item.ts
    local dt = now - ts
    for _, conf in ipairs(backupIntervalConfig) do
        local period = conf[1]
        if dt < period then
            return conf
        end
    end
    return nil
end

function canSelect(item, selected, conf)
    if #selected == 0 then
        return true
    end
    local last = selected[#selected]
    local lastTS = last.ts
    local ts = item.ts
    local dt = ts - lastTS
    local internal = conf[2]
    if dt > internal - TS_TOLERANT then
        return true
    end
    return false
end

function main()
    local unselected = {}
    for line in io.input():lines() do
        local year, month, day, hour, min, sec = string.match(line, "(%d%d%d%d)-(%d%d)-(%d%d)_(%d%d)(%d%d)(%d%d)")
        year = tonumber(year)
        month = tonumber(month)
        day = tonumber(day)
        hour = tonumber(hour)
        min = tonumber(min)
        sec = tonumber(sec)
        if year and month and day and hour and min and sec then
            local ts = os.time { year=year, month=month, day=day, hour=hour, min=min, sec=sec}
            table.insert(unselected, { ts = ts, v = line })
        end
    end

    table.sort(unselected, function(a, b)
        return a.ts < b.ts
    end)

    local selected = {}
    local garbage = {}

    for _, item in ipairs(unselected) do
        local conf = selectConfig(item)
        if conf then
            if canSelect(item, selected, conf) then
                table.insert(selected, item)
            else
                table.insert(garbage, item)
            end
        end
    end

    for _, item in ipairs(garbage) do
        print(item.v)
    end
end

main()

