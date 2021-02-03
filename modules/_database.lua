
return function()


    function isdate(value)
        if (string.match(value, "^%d+%p%d+%p%d%d%d%d$")) then
            local d, m, y = string.match(value, "(%d+)%p(%d+)%p(%d+)")
            d, m, y = tonumber(d), tonumber(m), tonumber(y)
    
            local dm2 = d*m*m
            if  d>31 or m>12 or dm2==0 or dm2==116 or dm2==120 or dm2==124 or dm2==496 or dm2==1116 or dm2==2511 or dm2==3751 then
                -- invalid unless leap year
                if dm2==116 and (y%400 == 0 or (y%100 ~= 0 and y%4 == 0)) then
                    return "valid"
                else
                    return "invalid"
                end
            else
                return "valid"
            end
        else
            return "invalid"
        end
    end
    
    
    function BloodData.CreateNewData()
        local Success, Error = pcall(function() 
            local bgroup, name, DoB, mobile, location

            print("Please type the Blood Type.")
            bgroup = io.read():upper()
            if Misc.CheckBlood(bgroup) ~= true then 
                print("Invalid Blood Group, please recheck the data.")
                APP.OpenApplicationCommands() 
            return end
            bgroup = tostring(bgroup)
            
            print("Please write the donor's name")
            name = io.read()
            name = tostring(name)

            -- os.date("%d/%m/%Y")  

            print("Please write Donor's Date of Birth. MUST BE like DATE/MONTH/YEAR")
            DoB = io.read()
            if isdate(DoB) == "valid" then
                DoB = DoB
            else 
                print("Invalid Date of Birth")
                APP.OpenApplicationCommands()
            end

            print("Plaese write mobile number, EXAMPLE: 01712345678")
            mobile = io.read()
            if mobile:len() == 11 then
                mobile = tostring(mobile)
            else 
                print("Invalid Mobile Number.")
                APP.OpenApplicationCommands() 
            return end

            print("Please write the location.")
            location = io.read()
            location = tostring(location)

            os.execute("cls")
            print(bgroup, name, DoB, "0"..mobile, location, os.date("%d/%m/%Y"), 0)
            
            BloodData.Insert(bgroup, name, DoB, mobile, location)
        end)
        if not Success then
            print("Unexpected Error found, returning to main interface.")
            App.OpenApplicationCommands()
        end

    end

    function BloodData.Insert(bg, name, dob, mobile, location)
        local Success, Error = pcall(function() 
            local eValue = SQL:prepare(string.format("INSERT INTO BloodDB VALUES(?, ?, ?, ?, ?, ?, ?);"))
            eValue:reset():bind(bg, name, dob, mobile, location, os.date("%d/%m/%Y"), 0):step()
            APP.OpenApplicationCommands()
        end)
        if not Success then
            print("Database related error, please contact the developer, returning to the main interface.")
            App.OpenApplicationCommands()
        end

    end
    
    
    function BloodData.ViewAll()
        local Suc, Err = pcall(function() 
            local dValue, dCount = SQL:exec("SELECT * FROM BloodDB")
            if dCount == 0 then 
                print("There no entry found, please add first.")
                APP.OpenApplicationCommands()
            return end
            print("number", "Blood Group", "Donor's Name", "Date of Birth", "Mobile Number", "Location", "Reg-Date", "Donated")
            for i = 1, dCount do
                p(i, dValue.bloodgroup[i], dValue.name[i], dValue.DoB[i], "0"..tonumber(dValue.MNumber[i]), dValue.Location[i], dValue.RegDate[i], tonumber(dValue.donated[i]))
                --p(data)
            end
            
            APP.OpenApplicationCommands()
        end)
        if not Suc then
            print("Database related error, Please contact the developer, returning to the main interface.")
            APP.OpenApplicationCommands()
        end
    end

end