# Nginx Stats Scout Plugin

[Scout](http://scoutapp.com/) plugin to monitor and gather statistics of a nginx server.

This plugin is based on the scout-nginx-status-plugin plugin written by Luc Castera [http://github.com/dambalah/](http://github.com/dambalah).

## Modified by

### Colin Surprenant, Praized Media

* [http://www.praizedmedia.com/](http://www.praizedmedia.com/)
* [http://github.com/colinsurprenant/](http://github.com/colinsurprenant/) 
* [http://eventuallyconsistent.com/blog/](http://eventuallyconsistent.com/blog/)

## Modifications to the original sources

* refactored the status parsing
* added the average requests per second computation
* fixed the yml config file which must have the same name as the plugin

## Usage

In order to have this plugin running, you need to make sure that your 
version of Nginx was compiled with the Stub Status module.

On Ubuntu Hardy, the nginx package comes with Stub Status compiled in so 
if you installed Nginx via apt-get or aptitude, you should have it.

Make sure you have the following in your nginx config file:

location /nginx_status {
	stub_status on;
	access_log   off;
	allow 127.0.0.1;
	deny all;
}

## Changelog

**Version 1.0: 2009-03-20**

* (Colin Surprenant) refactored the status parsing
* (Colin Surprenant) added the average requests per second computation
* (Colin Surprenant) fixed the yml config file which must have the same name as the plugin

**2008-07-30**

* (Luc Castera) Inital release.

