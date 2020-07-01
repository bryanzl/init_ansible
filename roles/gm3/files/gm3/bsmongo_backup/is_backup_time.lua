function split(s, d)
    local t = {}
    string.gsub(s, '[^' .. d .. ']+', function (s_)
        table.insert(t, s_)
    end)
    return t
end

function main()
    if not arg[1] then
        os.exit(1)
    end
    local arr = split(arg[1], ',')
    local minute = os.date('*t').min
    for _, x in ipairs(arr) do
        x = tonumber(x)
        if x then
            if x == minute then
                os.exit(0)
            end
        end
    end
    os.exit(2)
end

main()