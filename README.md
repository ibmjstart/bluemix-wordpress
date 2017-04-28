WordPress on Bluemix
================================================================================

WordPress is an open source content management system (CMS) that is popular with 
both businesses and bloggers. WordPress is extendable and customizable through 
themes, plugins, and templates that make it easy to transform the site to meet 
your exact needs.

WordPress on Bluemix uses the [Composer package manager](https://getcomposer.org) to install the 
[wordpress package from johnpbloch](https://packagist.org/packages/johnpbloch/wordpress) 
and configures the installation to use Compose (MySQL) for data and IBM Object Storage 
for media.

[![Deploy to Bluemix](https://bluemix.net/deploy/button_x2.png)](https://bluemix.net/deploy?repository=https://github.com/ibmjstart/bluemix-wordpress)

> ATTENTION: Since only one instance of the Object Storage Free plan is allowed per organization, this repository defaults to use of the standard plan

---
# Configure Your Site
1.  After your application starts, open it in a web browser (typically at a URL like http://&lt;your-hostname&gt;[.your-region].mybluemix.net.
2.  Follow the steps to configure your WordPress website for the first time.

## Configure SendGrid
The SendGrid plugin is included by default, but must be activated.
To add email support to your WordPress site:

  1. Create a SendGrid instance from the Bluemix catalog and bind it to your WordPress app
  2. Log in to your WordPress dashboard and enable the SendGrid plugin
  3. Select `Settings > SendGrid` and enter your SendGrid credentials (available via "Show Credentials" in the web UI or `cf env` from the [cf cli](https://github.com/cloudfoundry/cli))
  4. Configure the other email settings:
    * Name: The name that you want the email to be from.
    * Sending Address: The address that the email appears to originate from.
    * Reply Address: The email that replies are sent to. Choose a working, existing email that you use.
    * Categories: Any categories that you want to attach to your messages.

## Activate the WP Super Cache Plugin
1.  Navigate to the plugins page in the admin dashboard.
2.  Find the WP Super Cache plugin in the list and click Activate
3.  A message at the top of the page says, 

    ```
"WP Super Cache is disabled. Please go to the plugin admin page to enable caching." 
Click on the plugin admin page.
    ```

4. If you are directed to a page that says, "Permalink Structure Error", a custom URL or permalink structure is required for the plugin to work correctly. 
    * Go to the Permalinks Options Page to configure the permalinks. 
    * Click the Permalinks Options Page link and choose a new permalink structure. 
    * Hit Save Changes. A common choice here is month and name.

5. Navigate to the WP Super Cache settings under the Settings Tab. 
6. Turn caching on. Hit Update Status.

**Congratulations! You are now using caching!**

## Customize Your WordPress
WordPress on Bluemix uses the [Composer package manager](https://getcomposer.org) 
for both the installation of the WordPress core and also for the installation of all 
plugins and themes.

Applications on Bluemix have an ephemeral filesystem, meaning that each time your 
application is restaged, the container that stores the files is destroyed and 
recreated from the application package. Therefore, WordPress on Bluemix disables 
in-place upgrades and warns against the web-based installation of plugins and themes.

Instead, to edit your installation, you must modify the composer.json file and re-push 
the application to Bluemix.
1.  Git clone your project repo or edit your application using Bluemix DevOps Services
2.  Modify composer.json with the set of plugins and themese you wish to install
3.  Push your changes to Bluemix using Bluemix DevOps Services or the cf cli
  * For more info on the Cloud Foundry command-line interface, see 
[Deploying your app with the command line interface](https://www.ng.bluemix.net/docs/starters/install_cli.html)

>The default composer config from this repository will install the latest stable 
WordPress package, each time the application is staged. If you would like to avoid 
unexpected upgrades, please change the following line in composer.json 
in order to lock into a specific version or version range:
>
```
"johnpbloch/wordpress"                        : "*",
```

After each update to WordPress core, you may need to apply changes to the database. 
WordPress should detect this and prompt you to run the database update from the 
WordPress dashboard (https://<your-site>/wp-login.php).

---

Contributing to the wp-openstack-objectstorage plugin, look [here](CONTRIBUTING.md) on how
to make your changes work.

---
# FAQ
## What plugins are installed by default?
*   Disable Updates Manager: As Bluemix does not use a persistent file system, using the automatic update buttons in the WordPress UI would cause updates and plugins that you install to disappear after your app restarts. The Disable Updates Manager hides the update notifications for WordPress Core, plugins, and themes by default. You are welcome to change this setting, but keep in mind that all updates to your WordPress installation are handled by the composer package manager during the restaging your application.
*   Object Storage: Handles all media uploads for your WordPress site.
*   SendGrid: SendGrid provides email integration with your website.
*   WP Super Cache: A popular WordPress optimization plugin that uses caching to speed up your blog.

Note: the SendGrid and WP Super Cache plugins must be manually enabled

## How can I persist my wp-config.php changes?
>One of the most important files in your WordPress installation is the wp-config.php file. This file is located in the root of your WordPress file directory and contains your website's base configuration details, such as database connection information.

This repository's composer.json **requires** a [github repository](https://github.com/ibmjstart/wp-bluemix-config) which provides a specially crafted **default** [wp-config.php](https://github.com/ibmjstart/wp-bluemix-config/blob/301a194a37b0cf0390f35dea8d91ab89a00dfebc/wp-config.php).  After deployment, you may choose to perform additional administrative actions (e.g.  Activating/enabling WP Super Cache, etc ...) which **can** potentially modify the Bluemix application's wp-config.php.  Given the ephemeral nature of Cloud Foundry container file systems, you must capture and persist this in-use wp-config.php within the repository or risk losing your admin actions entirely upon application restart/update.  

To persist requires a 3 step process ...

####Step 1  

```
# Clone your deployment repo and make it the current working directory
$ git clone your_open_toolchain_github_repo_or_hub_jazz_net_repo
$ cd your_git_repo
```
####Step 2
```
# Fetch the current wp-config.php file and save it to the lib folder
$ cf ssh appName -c "cat ~/app/htdocs/wp-config.php" > ./lib/wp-config.php
```

####Step 3  

```
# Modify composer.json commands to move your persisted file into the expected location,
# rather than the default one.

"post-xxxxxx-cmd" : [
            [...]
            "mv lib/wp-config.php htdocs",
            [...]
        ]
```
Both the **post-update-cmd** and **post-install-cmd** sections should be updated to look like this:

```
"post-xxxxxx-cmd" : [
            "mv vendor/ibmjstart/wp-bluemix-config/mu-plugins htdocs/wp-content/mu-plugins",
            "mv vendor/ibmjstart/wp-bluemix-config/.user.ini htdocs",
            "mv lib/wp-config.php htdocs",
            "mv vendor htdocs/vendor",
            "mv lib/.htaccess htdocs"
        ]
```

Finally, commit your changes to your git repo.  The continuous delivery pipeline will trigger and redeploy your Wordpress application -- with a persisted wp-config.php.

####Subsequent Admin Actions  

>Any number of subsequent Wordpress admin changes can be recaptured by executing **Step 2** again ...<br/>
>and committing your changes to the git repository.

```
$ cf ssh appName -c "cat ~/app/htdocs/wp-config.php" > ./lib/wp-config.php
```


## What is IBM Object Storage?
IBM Object Storage is a service that exposes OpenStack Swift APIs for storing "objects" like files.

IBM Object Storage is useful because WordPress traditionally relies on the local file 
system for things like media uploads. Bluemix, like other cloud platform, recycles 
the application container each time the application is staged. This action would 
result in losing your media files every time that you push or restart your Bluemix app. 
With IBM Object Storage, files are uploaded to the service so that they are never 
lost. The SoftLayer Swift plugin within WordPress provides an admin settings page so that you can 
manage your containers and your upload options.

## What is SendGrid?
SendGrid is an easy to use email service that that enables your WordPress website to send emails for things like forgotten passwords or comment notifications.

## Using Composer to manage your WordPress application.
WordPress on Bluemix uses composer, a PHP dependency manager, to dynamically install your plugins and themes. You can manage all plugins, even the WordPress core version, via composer by modifying the composer.json file.
  
  *   Open the composer.json file. Under the required section, you enter the information for what is being added. There is a specific composer vendor, wpackagist, that mirrors WordPress' SVN repositories for both plugins and themes. This creates a simple way to add more plugins and themes.
  *   If you want to specify a version of WordPress, you can change the following line: "johnpbloch/wordpress" : "\*". The \* can be replaced with your desired version number. For more information about the version notation, see [package versions](https://getcomposer.org/doc/01-basic-usage.md#package-versions "(Opens in a new tab or window)").
  *   If you are adding a plugin, the vendor name is wpackagist-plugin. The package name is whatever the plugin developer registered their plugin as. If you want to install a plugin that is called hello-world, then add wpackagist-plugin/hello-world in the require section.
  *   Adding a theme follows a similar model, but the vendor name is wpackagist-theme
  *   After that, specify a version number. You can use * to grab the most up-to-date version of a plugin. For themes, use the * in all cases.
    Example:
    
    ```
    "wpackagist-plugin/hello-world": "*"
    "wpackagist-theme/twentytwelve: "*"
    ```
    
For more information on packages and themes, see [WordPress Packagist](http://wpackagist.org/ "(Opens in a new tab or window)").

  *   After you add plugins and themes, run composer update in a terminal that is in the same directory as your composer.json file. This action generates the composer.lock file that the buildpack uses to install everything, and also downloads the files that are specified in composer. Because they are downloaded again when you push, you should either add these folders to your .cfignore file, or delete them before you push.
  *   Do a cf push. When the app is pushed, the buildpack uses the composer.lock file to download all of the files you've specified. They are then available to you in WordPress.
  *   If you want to lock version numbers instead of always getting the latest, you can specify all version numbers in the composer.json file. Otherwise, you can install composer and run composer locally to generate a composer.lock file before pushing.

## Incorporating Private Plugins with Composer
Private and premium Wordpress plugins can be challenging to incorporate in this code repository.  Unlike public themes and plugins which can be obtained via wpackagist or another publically accessible git repository, private plugins usually need to be present as a local asset.  To leverage private plugins, you will need to do the following 3 steps:

1. Download and extract your Private Wordpress Plugin(s) into separate subfolder(s) under the parent folder named **lib** which is located at the root of this repository.  The parent folder name must remain as **lib** to ensure that the PHP CloudFoundry buildpack leaves the contents alone.
2. For each private plugin, add a composer.json file to the root of the folder with something similar to the following:

   ```
	{
	  	"name": "thethemefoundry/make-plus",
	  	"type": "wordpress-plugin",
	  	"keywords": ["wordpress", "plugin"],
	  	"license": "This software is NOT to be distributed, but can be INCLUDED in WP themes: Premium or Contracted.",
	  	"require": {
	    	"php": ">=5.3.2",
	    	"composer/installers": "v1.0.7"
	  	}
	}
	```
	
3. Finally, we need to tell composer where to place this privately sourced plugin folder.  Modify this projects composer.json within the **post-install-cmd** and **post-update-cmd** arrays to include a command for **moving** your private plugin content to the wp-content plugins folder.  The command will look similar to this:

   ```
   "mv lib/my-personal-plugin-folder htdocs/wp-content/plugins"
   ```    

## My WordPress site received an "Error establishing a database connection" or "Service Unavailable" message.

>![503 Error](./service_unavailable_error.png)
>**503 Service Unavailable**

You probably have too many concurrent users who are trying to access your website OR the web installer has tried to establish too many concurrent connections to the MySQL service. 
By default, WordPress on Bluemix uses the Standard tier of Compose's MySQL database as 
a service that is suitable for trial usage. However, for real usage, consider 
upgrading the resource allocations which provide you with more simultaneous 
connections and more storage space.

You can also try [activating the WP Super Cache Plugin](#activate-the-wp-super-cache-plugin).

## How can I bind an alternate mysql:// DB service url to my WordPress instance?
Bluemix supports the concept of a User-Provided Service [CUPS](https://docs.cloudfoundry.org/devguide/services/user-provided.html).  You will simply need to identify the **mysql://** url from your service provider's web ui ...

Create a custom MySQL User-Provided Service via this command:

```
cf cups myCustomDB -p '{"uri":"mysql://USER:PASSWORD@COMPOSE_REGION:PORT/compose"}'
```

>You will need to update the manifest.yml within your project's git repository to reflect this new service instance name **AND** bind this new user-provided service to your application while unbinding the default MySQL service instance provided by this repository.  To illustrate: 
>
>**BEFORE** [manifest.yml]
>
>```
>[...]
>services:
>- myObjectStorage
>- myComposeMySQL
>```
>**AFTER** [manifest.yml]
>
>```
>[...]
>services:
>- myObjectStorage
>- myCustomDB
>```
>```
>cf unbind-service appname myComposeMySQL
>cf bind-service appname myCustomDB
>```

During application deployment, the environment variable parsing routines within the [wp-bluemix-config repository](https://github.com/ibmjstart/wp-bluemix-config/blob/301a194a37b0cf0390f35dea8d91ab89a00dfebc/wp-config.php#L36-L50) will detect the user-provided service instance and populate the configuration accordingly during app restaging.
>Remember: Association to a new empty DB will trigger the WordPress web installation sequence.


## My site is loading slowly. Can I speed it up?
Bluemix provides built-in support for scaling your apps. If the slowdown is load-related, 
increasing the number of instances may improve response times. You can also try [activating 
the WP Super Cache Plugin](#activate-the-wp-super-cache-plugin).

## I received an HTTP error when I tried to upload an image.
Check the health of the Object Storage service in your region via https://ibm.biz/bluemixstatus

## Routes to my posts and pages start failing unexpectedly
The .htaccess is a distributed config file.  Wordpress uses this file to manipulate how Apache serves files from its root directory and subdirectories thereof.  Most notably, WP modifies this file to be able to handle pretty permalinks. An example of a default version can be found [here](https://codex.wordpress.org/htaccess) . If your routes unexpectedly stop working until you reset your permalinks settings within the Admin dashboard, then you are most likely dealing with a .htaccess file that is either corrupt or being deleted after app restart.  Use the **cf files** or the Bluemix dashboard to inspect the .htaccess file which should be present at */app/htdocs/.htaccess*.  Visit the **lib** folder of this repository and update the .htaccess default file provided in this repo.  

## Can I upload files larger than 500 MB?
This value, along with several others, is defined in the .user.ini file in the root directory. You can change the value to anything you like, but keep in mind that the default disk quota in a Bluemix app is 1 GB, and it can be a maximum of 2 GB.

## How do I upgrade this app from a previous version?
Newer versions of this repository use composer with loose version ranges in order to help keep this project up-to-date (at the cost of some stability). Simply restage your application to pick up the updated dependencies.

If you have installed a previous version of the boilerplate that used Object Storage (v1), please see the following instructions for how to migrate your WordPress from Object Storage v1 to the new Object Storage service on Bluemix: http://blog.ibmjstart.net/2015/11/30/migrating-wordpress-on-bluemix

