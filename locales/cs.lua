local Translations = {
    error = {
        ["invalid_job"] = "Nemyslím si, že zde pracuji...",
        ["invalid_items"] = "Nemáte správné předměty!",
        ["no_items"] = "Nemáte žádné předměty!",
    },
    progress = {
        ["pick_grapes"] = "Sbírání hroznů...",
        ["process_grapes"] = "Zpracování hroznů...",
    },
    task = {
        ["start_task"] = "[E] Zahájit",
        ["load_ingrediants"] = "[E] Načíst ingredience",
        ["wine_process"] = "[E] Zahájit proces výroby vína",
        ["get_wine"] = "[E] Získat víno",
        ["make_grape_juice"] = "[E] Vyrobit hroznový džus",
        ["countdown"] = "Zbývající čas %{time}s",
        ['cancel_task'] = "Zrušili jste úkol"
    },
    text = {
        ["start_shift"] = "Zahájili jste svou směnu ve vinici!",
        ["end_shift"] = "Vaše směna ve vinici skončila!",
        ["valid_zone"] = "Platná zóna!",
        ["invalid_zone"] = "Neplatná zóna!",
        ["zone_entered"] = "Vstoupil(a) jste do zóny %{zone}",
        ["zone_exited"] = "Opustil(a) jste zónu %{zone}",
    }
}

if GetConvar('qb_locale', 'en') == 'cs' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
--translate by stepan_valic