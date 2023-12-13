local Translations = {
    error = {
        invalid_items = 'Du hast nicht die korrekten Gegenstände!',
    },
    progress = {
        pick_grapes = 'Sammle Weintrauben ..',
        process_wine = 'Processing Wine',
        process_juice = 'Processing Grape Juice'
    },
    task = {
        start_task = '[E] zum Starten',
        vineyard_processing = '[E] Vineyard Processing',
        cancel_task = 'Du hast deine Aufgabe Abgebrochen'
    },
    menu = {
        title = 'Vineyard Processing',
        process_wine_title = 'Process Wine',
        process_juice_title = 'Process Grape Juice',
        wine_items_needed = 'Required Item: Grape Juice\nAmount Needed: %{amount}',
        juice_items_needed = 'Required Item: Grape\nAmount Needed: %{amount}'
    }
}

if GetConvar('qb_locale', 'en') == 'de' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end