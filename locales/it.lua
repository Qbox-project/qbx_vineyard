local Translations = {
    error = {
        invalid_items = 'Non hai gli oggetti corretti!',
    },
    progress = {
        pick_grapes = 'Raccogliendo l\'uva ..',
        process_wine = 'Processing Wine',
        process_juice = 'Processing Grape Juice'
    },
    task = {
        start_task = '[E] Per Cominciare',
        vineyard_processing = '[E] Vineyard Processing',
        cancel_task = 'Hai cancellato il compito'
    },
    menu = {
        title = 'Vineyard Processing',
        process_wine_title = 'Process Wine',
        process_juice_title = 'Process Grape Juice',
        wine_items_needed = 'Required Item: Grape Juice\nAmount Needed: %{amount}',
        juice_items_needed = 'Required Item: Grape\nAmount Needed: %{amount}'
    }
}

if GetConvar('qb_locale', 'en') == 'it' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end