express = require "express"
app = express()
puppeteer = require "puppeteer"
bodyParser = require "body-parser"

app.use bodyParser.urlencoded extended: true

console.log extended: true

app.use bodyParser.json()

app.get "/", (req, res) ->
    res.sendFile __dirname + "/index.html"

app.post "/", (req, res) ->
    if !req.body.gameId
        return res.send "No game id."
    res.send req.body.gameId

    asyncFunc1 = (id) ->
        browser = await puppeteer.launch headless: false
        page = await browser.newPage()

        await page.goto "https://www.blooket.com/play"
        await page.type ".styles__idInput___HAiip-camelCase", id.toString()
        await page.click '.styles__joinButton___3imrw-camelCase'

        await page.waitForNavigation()

        await page.type ".styles__nameInput___3LvwC-camelCase", "a"
        await page.click '.styles__joinButton___3XV3H-camelCase'

        await page.waitForNavigation()

        loginNeeded = await page.evaluate -> 
            el = document.querySelector ".styles__loginButton___2u42V-camelCase"

            if el then return true else return false

        if loginNeeded = true 
            await page.click '.styles__loginButton___2u42V-camelCase'

            await page.type '[placeholder="Username/Email"]', req.body.email.toString()
            await page.type '[placeholder="Password"]', req.body.pass.toString()
            await page.click '.styles__button___15euw-camelCase'

            interval = null
            stop = false

            answerQuestions = () ->
                if stop == true then return console.log "stop!"
                await page.click ".arts__regularBody___3lHde-camelCase"
                try
                    await page.click ".styles__answerContainer___2Xv-a-camelCase"
                catch e

                    try
                        await page.click ".styles__choice3___3rfjI-camelCase"
                    catch e2
                        await page.click ".arts__regularBody___3lHde-camelCase"
                await page.click ".arts__regularBody___3lHde-camelCase"

                console.log "answered"
            
            await page.waitForNavigation()
            await page.waitForNavigation()
            
            interval = setInterval answerQuestions, 1000
            
            while true
                await page.waitForNavigation()
                console.log page.url()
                if page.url() == "https://www.blooket.com/play/gold/final" then break

            stop = true

            clearInterval interval
            interval2 = null

            intFunc = () -> 
                coins = await page.evaluate -> 
                    el2 = document.querySelector ".styles__prizeNumberText___15RZu-camelCase"

                    if el2 then return true else return false
                if coins == true
                    page.click ".styles__prizeNumberText___15RZu-camelCase"

                    timeout = ->
                        clearInterval interval
                        browser.close()
                    
                    clearInterval interval
                    clearInterval interval2

                    setTimeout timeout, 60000

            interval2 = setInterval intFunc, 1000
            
            clearInterval interval

            return
        
    asyncFunc1 req.body.gameId


app.listen "2000", null