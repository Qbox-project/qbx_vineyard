local Translations = {
    error = {
        invalid_items = 'Sinulla ei ole oikeita esineitä!',
    },
    progress = {
        pick_grapes = 'Kerätään rypäleitä ..',
        process_wine = 'Processing Wine',
        process_juice = 'Processing Grape Juice'
    },
    task = {
        start_task = 'Paina [E] aloittaaksesi',
        vineyard_processing = '[E] Vineyard Processing',
        cancel_task = 'Olet peruuttanut tehtävän!'
    },
    menu = {
        title = 'Vineyard Processing',
        process_wine_title = 'Process Wine',
        process_juice_title = 'Process Grape Juice',
        wine_items_needed = 'Required Item: Grape Juice\nAmount Needed: %{amount}',
        juice_items_needed = 'Required Item: Grape\nAmount Needed: %{amount}'
    }
}

if GetConvar('qb_locale', 'en') == 'fi' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end