ubuntu-twilio-updater
=====================

An updater for ubuntu you can put in a cron job, and get text message updates from twilio

## Setup

1. Create a twilio account
2. Copy ubuntu_updater.example.yml to ubuntu_updater.yml
    
    cp ubuntu_updater.example.yml ubuntu_updater.yml

3. Update ubuntu_updater.yml with your twilio settings
4. Setup a cron job to run as root, at your desired interval

## Pseudo Code

If there are updates
  Send text to everyone in the "always_send" array with number of updates to be performed
  Update the server
  If update was successful
    Send a text to everyone in the "always_send" array saying the update was a success
  Else
    Send a text to everyone in the "always_send" array and the "error_send" array saying the update was a failure
