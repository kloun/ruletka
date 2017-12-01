dofile "db.lua"
local num = 12
local win = 1
math.randomseed(os.time())

-- магия
local handle = io.popen('whoami')
local user = handle:read("*a")
handle:close()
user = user:gsub("^%s*(.-)%s*$", "%1")

local id = dbGetUserID(user)
if id == 0 then
  id = dbAddUser(user)
end

function ruletka()
  local countwins = 0
  for i = 1,num do
    ::Input::
    local s = tonumber(io.read())
    if (s == nil) or (s<1) or (s>num) then
      print("неподдерживаемое значение") 
      goto Input
    end
    local v = math.random(1,num)
    if s == v then
      print('вы угадали, на  рулетке выпало значение ', v)
      countwins = countwins+1 
    else 
      print('вы не угадали, на  рулетке выпало значение ', v)
    end
    if countwins > win then 
      break 
    end
  end
  if countwins > win then
    return 3
  elseif countwins > 0 then 
    return 1
  end
  return -3
end

if arg[1] ~= '-s' then
  local gamescore = ruletka()
  dbAddGame(id, gamescore)
end

print('количество сыгранных партий: ', dbCountGames(id, 0), '\nв том числе полностью выигранных:',
  dbCountGames(id, 3), '\n(последняя игра: '..dbGetDateLast(id,3)..')',
  '\nчастично выигранных:', dbCountGames(id, 1),'\n(последняя игра: '..dbGetDateLast(id,1)..')', 
  '\nпроиграннных:', dbCountGames(id, -3), '\n(последняя игра: '..dbGetDateLast(id,-3)..')')
print('\nваш рейтинг:' , dbGetRaiting(id))
print('место в рейтинге: ', dbGetRank(id))