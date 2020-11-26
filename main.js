const Discord = require('discord.js')
const axios = require('axios')
require('dotenv').config()
const { createLogger, format, transports } = require('winston');

const admins = ['barnesly#3670']
const CMD_PREFIX = '!'
const LOG_LEVEL = process.env.LOG_LEVEL || 'info'
const BOT_TOKEN = process.env.BOT_TOKEN
const API_TOKEN = process.env.API_TOKEN
const API = process.env.API
const API_USERS = API + '/users'

const HELP_TEXT = `Commands:
!stats - show your current stats
!won - increment your win count by 1
!lost - increment your lost count by 1
!high <score> - udpate your high score
!picture <url>  - update your profile picture
`

// Configure logging
const logger = createLogger({
    level: LOG_LEVEL,
    format: format.combine(
      format.timestamp({
        format: 'YYYY-MM-DD HH:mm:ss'
      }),
      format.errors({ stack: true }),
      format.splat(),
      format.json()
    ),
    defaultMeta: { service: 'ttrl-bot' },
    transports: [
      new transports.File({ filename: 'ttrl-errors.log', level: 'error' }),
      new transports.File({ filename: 'ttrl.log' }),
      new transports.Console({
          format: format.combine(
            format.colorize(),
            format.simple()
          )
        })
    ]
  });


// Configure Discrod Bot
const bot = new Discord.Client();

bot.on('ready', function() {
    const { username, id, tag } = bot.user
    logger.info(`Logged in as ${username} - ${id} - %${tag}`)
});


bot.on('message', msg => {

    const { content } = msg

    if (!content.startsWith(CMD_PREFIX)) {
        return
    }

    logger.verbose(content)
    const args = content.slice(CMD_PREFIX.length).trim().split(/\s+/)
    const command = args.shift().toLowerCase();

    const  { author } = msg;
    const { tag } = author
    const authorInfo = asInfoString(author)
    switch (command) {
        case 'ping':
            msg.channel.send(`Shutup ${author}`);
            break;
        case 'ttrl':
            msg.channel.send(HELP_TEXT);
            break;
        case 'won':
            logger.verbose("Updating wins for " + authorInfo)
            userUpdateOp(author, "win",
                r => msg.channel.send(`${author} - I've updated your win count`)
            )
            break;
        case 'lost':
            logger.verbose("Updating losses for " + authorInfo)
            userUpdateOp(author, "lose",
                r => msg.channel.send(`${author} - I've updated your lost count`)
            )
            break;
        case 'picture':
            logger.verbose("Updating profile picture for " + authorInfo)
            userUpdateValueOp(author, "picture", args[0],
                r => msg.channel.send(`${author} - I've updated your picture`)
            )
            break;
        case 'high':
            logger.verbose("Updating high score for " + authorInfo)
            userUpdateValueOp(author, "high", args[0],
                r => msg.channel.send(`${author} - I've updated your high score`)
            )
            break;
        case 'stats':
            logger.verbose("Retrieving user stats for " + authorInfo)

            const endpoint = API_USERS + "/" + encodeURIComponent(tag)

            logger.http('Calling API GET', {
                endpoint,
            })
            axios
                .get(endpoint)
                .then(response => {
                    logger.http('API GET call successful', {
                        body: response.data
                    })
                    let { wins, losses, high } = response.data
                    msg.channel.send(`Wins: ${wins}, Losses: ${losses}, High Score: ${high}`);
                })
            break;
    }
});

// Login
bot.login(BOT_TOKEN)

// Helper functions
function asInfoString({ tag, username, id }) {
    return `${username} (${tag} / ${id})`
}

function userUpdateOp(tag, operation, onSuccess) {
    return userUpdateValueOp(tag, operation, null, onSuccess)
}

function userUpdateValueOp(author, operation, opval, onSuccess) {
    const { tag } = author
    const endpoint = API_USERS + "/" + encodeURIComponent(tag)
    const body = {
        secret: API_TOKEN,
        operation,
        opval,
    }

    logger.http('Calling API PATCH', {
        endpoint,
        body,
    })

    axios
        .patch(endpoint, body)
        .then(response => {
            logger.verbose('API PATCH call successful', {
                endpoint,
            })
            onSuccess(response)
        })
        .catch(err => {
            logger.error(`Unable to update [${operation}->${opval}]for ${asInfoString(author)}: ${err}`)
            msg.channel.send(`Sorry ${author} - I broke :( (${err})`);
        })
}
