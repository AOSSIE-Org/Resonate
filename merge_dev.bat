@echo off
cd /d "c:\open source 1\Resonate"
git remote add upstream https://github.com/AOSSIE-Org/Resonate.git
git fetch upstream dev
git merge upstream/dev --no-edit
