local Translations = {
    error = {
        invalid_items = 'თქვენ არ გაქვთ სწორი ნივთები!',
    },
    progress = {
        pick_grapes = 'ყურძნის კრეფა ..',
        process_wine = 'Processing Wine',
        process_juice = 'Processing Grape Juice'
    },
    task = {
        start_task = '[E] Დაწყება',
        vineyard_processing = '[E] Vineyard Processing',
        cancel_task = 'თქვენ გააუქმეთ დავალება'
    },
    menu = {
        title = 'Vineyard Processing',
        process_wine_title = 'Process Wine',
        process_juice_title = 'Process Grape Juice',
        wine_items_needed = 'Required Item: Grape Juice\nAmount Needed: %{amount}',
        juice_items_needed = 'Required Item: Grape\nAmount Needed: %{amount}'
    }
}

if GetConvar('qb_locale', 'en') == 'ge' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end