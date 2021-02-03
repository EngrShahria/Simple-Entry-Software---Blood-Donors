_G.uv = require("uv")
_G.process = require("process").globalProcess()

require("io")
require("string")
_G.timer = require('timer')

local ThreadLoad = coroutine.resume
local sqlserver = require("sqlite3")
_G.SQL = sqlserver.open("BloodDatabase.db")

local F = string.format

--APPLICATION RELATED ALL GLOBAL VARIABLES 
_G.APP = {}
_G.BloodData = {}
_G.Misc = {}


--Load Modules
require("./modules/_database.lua")()


function Misc.split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

function Misc.IsANumber(num) --BOOL (True/False)
    local iNumber =  tonumber(num)
    if type(iNumber) ~= "number" then
        return false
    else return true
    end
end



function Misc.CheckBlood(data)
    if ((data == "A+") or
        (data == "A-") or
        (data == "B+") or 
        (data == "B-") or 
        (data == "AB+") or 
        (data == "AB-") or
        (data == "O+") or 
        (data == "O-")) then
        return true
    else
        return false
    end
end


function APP.OpenApplicationCommands()
    
    local suc, err = pcall(function() 
        ::applicationmethod::
        print("Please use the command to intract with the database.")
        print("Commands are: New, view, delete, information")
        local Command = io.read():lower() 
       -- if Command == nil then 
        if Command == "new" then
            BloodData.CreateNewData()
        elseif Command == "view" then
            BloodData.ViewAll()
        elseif Command == "exit" then 
            os.exit()
        else
            print("Invalid Input Command")
            goto applicationmethod
        end
    end)
    if not suc then 
        p("Invalid input, returned to the main interface!") 
        APP.OpenApplicationCommands()
    end
end

function LoadProgram()

	local C = coroutine.create(function()

	    print("Checking Database informations...")
	    timer.sleep('2000')
	    SQL:exec("CREATE TABLE IF NOT EXISTS BloodDB(bloodgroup VARCHAR(3) PRIMARY KEY, name TEXT, DoB DATE, MNumber INT,  Location TEXT, RegDate DATE, donated INT)")
        local _, count = SQL:exec("SELECT * FROM BloodDB")
        p("Database Loaded. Total Blood donators "..count)
	    timer.sleep("1000")
        print("Opening main interface of the program.")
        timer.sleep('2000')
        os.execute("cls")
        APP.OpenApplicationCommands()
    end)
    ThreadLoad(C)
end
LoadProgram()

process:on("sigint", function()
    
end)

uv.run()


