
const aws = require('aws-sdk');

exports.handler = async (event, context) => {
    const body = JSON.parse(event.body);
    return {
        statusCode: 200,
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(body),
        isBase64Encoded: false,
    }
};
// const Discord = require('discord.js')
// const axios = require('axios')
// require('dotenv').config()
// const { createLogger, format, transports } = require('winston');

// const admins = ['barnesly#3670']
// const CMD_PREFIX = '!'
// const LOG_LEVEL = process.env.LOG_LEVEL || 'info'
// const BOT_TOKEN = process.env.BOT_TOKEN
// const API_TOKEN = process.env.API_TOKEN
// const API = process.env.API
// const API_USERS = API + '/users'
// function apiUsersDiscordId(discordId) {
//     return API_USERS + "/" + encodeURIComponent(discordId)
// }

// const HELP_TEXT = `Commands:
// !register - register a new profile
// !stats - show your current stats
// !won - increment your win count by 1
// !lost - increment your lost count by 1
// !high <score> - udpate your high score
// !picture <url>  - update your profile picture
// !name <name> - update your name
// `

// // Configure logging
// const logger = createLogger({
//     level: LOG_LEVEL,
//     format: format.combine(
//       format.timestamp({
//         format: 'YYYY-MM-DD HH:mm:ss'
//       }),
//       format.errors({ stack: true }),
//       format.splat(),
//       format.json()
//     ),
//     defaultMeta: { service: 'ttrl-bot' },
//     transports: [
//       new transports.File({ filename: 'ttrl-errors.log', level: 'error' }),
//       new transports.File({ filename: 'ttrl.log' }),
//       new transports.Console({
//           format: format.combine(
//             format.colorize(),
//             format.simple()
//           )
//         })
//     ]
//   });

// if (!BOT_TOKEN) {
//     logger.error('BOT_TOKEN not set')
//     process.exit(1)
// }

// if (!API_TOKEN) {
//     logger.warn('API_TOKEN not set - mutation operations may not work')
// }

// // Configure Discrod Bot
// const bot = new Discord.Client();

// bot.on('ready', function() {
//     const { username, id, tag } = bot.user
//     logger.info(`Logged in as ${username} - ${id} - %${tag}`)
// });


// bot.on('message', msg => {

//     const { content } = msg

//     if (!content.startsWith(CMD_PREFIX)) {
//         return
//     }

//     logger.verbose(content)
//     const args = content.slice(CMD_PREFIX.length).trim().split(/\s+/)
//     const command = args.shift().toLowerCase();

//     const  { author, channel } = msg;
//     const { tag, username } = author
//     const authorInfo = asInfoString(author)

//     const discordIdEndpoint = apiUsersDiscordId(tag)

//     switch (command) {
//         case 'ping':
//             channel.send(`Shutup ${author}`);
//             break;
//         case 'ttrl':
//             channel.send(HELP_TEXT);
//             break;
//         case 'register':
//             logger.verbose("Registering user for " + authorInfo)

//             const body = {
//                 secret: API_TOKEN,
//                 discordId: tag,
//                 name: username,
//             }

//             logger.http('Calling API POST', {
//                 endpoint: API_USERS,
//                 body,
//             })
//             axios
//                 .post(API_USERS, body, {
//                     'content-type': 'application/json'
//                 })
//                 .then(response => {
//                     logger.http('API POST call successful', {
//                         body: response.data
//                     })
//                     channel.send(`${author} - you've been registered!`);
//                 })
//                 .catch(err => {
//                     logger.error(`Unable to register user ${asInfoString(author)}: ${err}`)

//                     let msgText
//                     switch (err?.response?.status) {
//                         case 409:
//                             msgText = `${author} - you're already registered`
//                             break;
//                         default:
//                             msgText = `Sorry ${author} - I broke :( (${err})`
//                     }
//                     channel.send(msgText);
//                 })
//             break;
//         case 'won':
//             logger.verbose("Updating wins for " + authorInfo)
//             userUpdateOp(msg, "win",
//                 r => channel.send(`${author} - I've updated your win count`)
//             )
//             break;
//         case 'lost':
//             logger.verbose("Updating losses for " + authorInfo)
//             userUpdateOp(msg, "lose",
//                 r => channel.send(`${author} - I've updated your lost count`)
//             )
//             break;
//         case 'picture':
//             logger.verbose("Updating profile picture for " + authorInfo)
//             userUpdateValueOp(msg, "picture", args[0],
//                 r => channel.send(`${author} - I've updated your picture`)
//             )
//             break;
//         case 'name':
//             logger.verbose("Updating name for " + authorInfo)
//             userUpdateValueOp(msg, "name", content.slice(CMD_PREFIX.length + 4 + 1),
//                 r => channel.send(`${author} - I've updated your name`)
//             )
//             break;
//         case 'high':
//             logger.verbose("Updating high score for " + authorInfo)
//             userUpdateValueOp(msg, "high", args[0],
//                 r => channel.send(`${author} - I've updated your high score`)
//             )
//             break;
//         case 'stats':
//             {}
//             logger.verbose("Retrieving user stats for " + authorInfo)

//             logger.http('Calling API GET', {
//                 endpoint: discordIdEndpoint,
//             })
//             axios
//                 .get(discordIdEndpoint)
//                 .then(response => {
//                     logger.http('API GET call successful', {
//                         body: response.data
//                     })
//                     let { wins, losses, high, picture } = response.data
//                     let embed = new Discord.MessageEmbed()
//                         .setColor('#0099ff')
//                         .setTitle(`${username}'s TTR Statistics`)
//                         .setThumbnail(picture)
//                         .addFields(
//                             { name: 'Wins', value: wins, inline: true },
//                             { name: 'Losses', value: losses, inline: true },
//                             { name: 'High Score', value: high, inline: true },
//                         )
//                     channel.send(embed)
//                 })
//                 .catch(err => {
//                     logger.error(`Unable to retrieve user stats for ${asInfoString(author)}: ${err}`)

//                     let msgText
//                     switch (err?.response?.status) {
//                         case 404:
//                             msgText = `${author} - you don't appear to be registered. You can do this with the "!register" command`
//                             break;
//                         default:
//                             msgText = `Sorry ${author} - I broke :( (${err})`
//                     }
//                     channel.send(msgText);
//                 })
//             break;
//     }
// });

// // Login
// bot.login(BOT_TOKEN)

// // Helper functions
// function asInfoString({ tag, username, id }) {
//     return `${username} (${tag} / ${id})`
// }

// function userUpdateOp(msg, operation, onSuccess) {
//     return userUpdateValueOp(msg, operation, null, onSuccess)
// }

// function userUpdateValueOp(msg, operation, opval, onSuccess) {
//     const { author, channel } = msg
//     const { tag } = author
//     const endpoint = apiUsersDiscordId(tag)
//     const body = {
//         secret: API_TOKEN,
//         operation,
//         opval,
//     }

//     logger.http('Calling API PATCH', {
//         endpoint,
//         body,
//     })

//     axios
//         .patch(endpoint, body)
//         .then(response => {
//             logger.verbose('API PATCH call successful', {
//                 endpoint,
//             })
//             onSuccess(response)
//         })
//         .catch(err => {
//             let msgText
//             switch (err?.response?.status) {
//                 case 404:
//                     msgText = `${author} - you don't appear to be registered. You can do this with the "!register" command`
//                     break;
//                 default:
//                     msgText = `Sorry ${author} - I broke :( (${err})`
//             }
//             logger.error(`Unable to update [${operation}->${opval}]for ${asInfoString(author)}: ${err}`)
//             channel.send(msgText);
//         })
// }
