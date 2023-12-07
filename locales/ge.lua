local Translations = {
    error = {
        invalid_job = 'არამგონია აქ ვიმუშაო...',
        invalid_items = 'თქვენ არ გაქვთ სწორი ნივთები!',
        no_items = 'თქვენ არ გაქვთ რაიმე ნივთი!',
    },
    progress = {
        pick_grapes = 'ყურძნის კრეფა ..',
        process_grapes = 'ყურძნის გადამუშავება..',
    },
    task = {
        start_task = '[E] Დაწყება',
        load_ingrediants = '[E] ჩატვირთეთ ინგრედიენტები',
        wine_process = '[E] დაიწყეთ ღვინის პროცესი',
        get_wine = '[E] მიიღეთ ღვინო',
        make_grape_juice = '[E] მოამზადეთ ყურძნის წვენი',
        countdown = 'Დარჩენილი დრო %{time}s',
        cancel_task = 'თქვენ გააუქმეთ დავალება'
    },
    text = {
        start_shift = 'You have started your shift at the vineyard!',
        end_shift = 'Your shift at the vineyard has ended!',
        valid_zone = 'Valid Zone!',
        invalid_zone = 'Invalid Zone!',
        zone_entered = '%{zone} Zone Entered',
        zone_exited = '%{zone} Zone Exited',
    }
}

if GetConvar('qb_locale', 'en') == 'ge' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end