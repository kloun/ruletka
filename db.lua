db = require("luasql.postgres") 
env = assert(db.postgres())
con = assert(env:connect("vr"))

function dbGetUserID(name)
  local cur=assert(con:execute("select id from users where name = '"..name.."';"))
  local ROW = cur:fetch({})
  if ROW == nil then
    return 0
  else
    return ROW[1]
  end
end

function dbAddGame(id, points) 
  assert(con:execute("insert into games (userid, points) values ("..tostring(id)..", "..points.. ");"))
end

function dbAddUser(user)
  local cur = assert(con:execute("insert into users (name) values ('"..user.."') RETURNING id;"))
  local ROW = cur:fetch({})
  return ROW[1]
end  

function dbCountGames(id, points)
 if id == 0 then
   return 0
 else
    if points == 0 then 
      local cur = assert(con:execute("select count(userid) from games where userid = '"..tostring(id).."';"))
      local ROW = cur:fetch({})
      if ROW[1] == nil then
        return 0 
      else 
        return ROW[1]
      end
    elseif points == 3 or points == 1 or points == -3 then
      local cur = assert(con:execute("select count(userid) from games where userid = '"..tostring(id).."' AND points ='".. tostring(points).."';"))
      local ROW = cur:fetch({})
      if ROW[1] == nil then
        return 0 
      else 
        return ROW[1]
      end
    end
  end
 end
 
function dbGetRaiting(id)
  cur = assert(con:execute("select raiting from users where id = "..id..";"))
  local ROW = cur:fetch({})
  return ROW[1]
end
 
function dbGetRank(id)
  cur = assert(con:execute('select r from (select dense_rank() over (order by raiting desc) as r, id from users) ranksel where id='..tostring(id)..';'))
  
  local ROW = cur:fetch({})
  
  if ROW[1] == nil then
    return 'неизвестно'
  else
    return ROW[1]
   end
end

function dbGetDateLast(id, points)
  cur = assert(con:execute('select max(date) from games where userid='..
    tostring(id)..' and points='..tostring(points)..';'))
  local ROW = cur:fetch({})
  if ROW[1] == nil then
    return 'неизвестна' 
  else
    return ROW[1]
  end
end
