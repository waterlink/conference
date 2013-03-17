
# Развертка окружения на машине разработчика

__Для Ubuntu__

'''bash
$ cd conference/deploy
$ ./install_capistrano.sh
$ cap nginx:install nginx:configure nginx:start php:install php:start setup_nginx_site
'''

# Развертка приложения

'''bash
$ cd conference/deploy
$ cap deploy
'''
