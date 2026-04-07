repeat task.wait() until game:IsLoaded()

-- Твоє посилання на виправлену бібліотеку
local libUrl = "https://raw.githubusercontent.com/Zayac333/MyRobloxScripts/main/ParentLibrary.lua?t=" .. tick()

-- Завантажуємо код
local success, rawCode = pcall(function() 
    return game:HttpGet(libUrl) 
end)

if success and rawCode then
    -- Виконуємо код бібліотеки
    local loadSuccess, result = pcall(function()
        return loadstring(rawCode)()
    end)
    
    if loadSuccess and result then
        print("Zayac Hub: Бібліотека завантажена успішно! 🐰🚀")
        return result -- Повертаємо об'єкт 'lib'
    else
        warn("Помилка при виконанні коду бібліотеки: " .. tostring(result))
    end
else
    warn("Не вдалося завантажити файл з GitHub!")
end

return nil
