-- Funktion, um die Fenstertönung der Fahrzeuge zu ändern
function CheckAndFixWindowTint()
    -- Hole alle Fahrzeuge im Spiel
    for vehicle in EnumerateVehicles() do
        if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
            -- Setze die Fenstertönung auf „Standard“ (keine Tönung)
            SetVehicleWindowTint(vehicle, 0) -- 0 bedeutet keine Tönung
        end
    end
end

-- Funktion, um über die Fahrzeuge zu iterieren
function EnumerateVehicles()
    return coroutine.wrap(function()
        local vehicleHandle = FindFirstVehicle()
        local success, vehicle = true, nil

        repeat
            success, vehicle = FindNextVehicle(vehicleHandle)
            if success and vehicle then
                coroutine.yield(vehicle)
            end
        until not success

        EndFindVehicle(vehicleHandle)
    end)
end

-- Timer, der alle paar Sekunden die Fahrzeuge überprüft
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)  -- Überprüfe alle 5 Sekunden
        CheckAndFixWindowTint()  -- Überprüfe und ändere die Fenstertönung
    end
end)

-- Event, das ausgelöst wird, wenn ein Spieler ein Fahrzeug spawnt
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    Citizen.Wait(1000)  -- Kurze Verzögerung, um sicherzustellen, dass das Fahrzeug geladen ist

    local playerPed = PlayerPedId()  -- Hole die Spielerfigur
    local vehicle = GetVehiclePedIsIn(playerPed, false)  -- Hole das Fahrzeug, falls der Spieler in einem sitzt

    -- Überprüfe, ob der Spieler sich in einem gültigen Fahrzeug befindet
    if vehicle ~= 0 and DoesEntityExist(vehicle) then
        -- Setze die Fenstertönung auf „Standard“ (keine Tönung)
        SetVehicleWindowTint(vehicle, 0) -- 0 bedeutet keine Tönung
    end
end)
