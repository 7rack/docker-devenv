#! /bin/bash
 
# git repo url,please fillin by yourself
project_url=""

export NODE_ENV="dev"
project_name=`basename "$project_url" | sed "s/.git//g"`

# Start deployment
# first time clone
[ ! -d "$project_name" ] && git clone $project_url

cd $project_name
#git reset --hard origin/master
#git clean -f
git pull
git checkout master
 
cnpm install && \
pm2 start app.js

#packaging for test/producting env
#cd .. && \
#tar czf $project_name-`date "+%Y%m%d%H%M%S"`.tgz $project_name
