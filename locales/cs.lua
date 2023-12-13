local Translations = {
    error = {
        invalid_items = 'Nemáte správné předměty!',
    },
    progress = {
        pick_grapes = 'Sbírání hroznů...',
        process_wine = 'Processing Wine',
        process_juice = 'Processing Grape Juice'
    },
    task = {
        start_task = '[E] Zahájit',
        vineyard_processing = '[E] Vineyard Processing',
        cancel_task = 'Zrušili jste úkol'
    },
    menu = {
        title = 'Vineyard Processing',
        process_wine_title = 'Process Wine',
        process_juice_title = 'Process Grape Juice',
        wine_items_needed = 'Required Item: Grape Juice\nAmount Needed: %{amount}',
        juice_items_needed = 'Required Item: Grape\nAmount Needed: %{amount}'
    }
}

if GetConvar('qb_locale', 'en') == 'cs' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end