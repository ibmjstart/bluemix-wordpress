WordPress on Bluemix
================================================================================

WordPress is an open source content management system (CMS) that is popular with both businesses and bloggers.

WordPress is extendable and customizable through themes, plugins, and templates that make it easy to transform the site to meet your exact needs. This boilerplate lets you quickly get your own WordPress website up and running on Bluemix™. When you go to the Bluemix catalog and deploy the boilerplate, you have the default WordPress application that you get from their website, along with services like IBM Object Storage and Sendgrid to help get you started.

___

##Deploy This Yourself##

Hit the button below to give it a shot. 

[![Deploy to Bluemix](https://hub.jazz.net/deploy/button.png)](https://bluemix.net/deploy?repository=https://hub.jazz.net/git/jstart/WordPress.on.Bluemix)

(Note: only one instance of the SendGrid service is allowed per space. If the deployment fails, that's probably why.)

Please note that this code is for developer education purposes only.   It is not intended to be used in a production environment. 

---
#Docs:

# About the App
This WordPress deploy includes everything you need to get up and running on Bluemix within minutes. IBM® Object Storage manages your media files and Sendgrid provides email integration. If you would like to further extend your WordPress site, you can download the application package and work with the code directly.
Finally, your database is provided by ClearDB, a MySQL database service provider.

 
###  Create a WordPress on Bluemix application:
1.  On the Bluemix dashboard, select CREATE AN APP and select the WordPress on Bluemix Starter.
2.  Provide your application name and host name.
3.  Select the service plans you want (default: free tier for all services).
4.  Click CREATE.  

### Go to your application:
1.  After your application starts, go to it at http://.mybluemix.net.
2.  Follow the steps to configure your WordPress website for the first time.

## Configure Sendgrid
The Sendgrid plugin is enabled by default in WordPress on Bluemix.
To configure Sendgrid, go to your admin dashboard, and then select Settings and then select Sendgrid. Your credentials are automatically completed by Bluemix, but you are free to change them (keep in mind that this action might break Sendgrid integration). Under mail settings, complete your settings according to the four options.
1.  Name: The name that you want the email to be from.
2.  Sending Address: The address that the email appears to originate from.
3.  Reply Address: The email that replies are sent to. Choose a working, existing email that you use.
4.  Categories: Any categories that you want to attach to your messages.

# Customizing WordPress
The Bluemix WordPress boilerplate uses the [Composer package manager](https://getcomposer.org/ "(Opens in a new tab or window)") to install the latest version of WordPress. Bluemix, like other cloud platforms, has an ephemeral filesystem. Every time your application is restaged, the container that stores the files is destroyed and recreated from the application package. Therefore, the Bluemix WordPress boilerplate disables upgrades that are already in place and warns against web-based plugin and theme installation. Instead, to edit your installation, simply download the starter code, modify the composer.json file, and re-push to Bluemix.
1.  Access your application and download the starter package.
    1.  If you are not already on your application page, go to your dashboard and select the app with the name you gave.
    2.  Click Start Coding and then select Download Starter code.
    3.  Your application downloads into a compressed file. Extract it into a directory of your choice.
2.  Edit your app.
    1.  Use composer to manager your plugins and themes. For more information on this, see [Using Composer to manage your WordPress application.](https://www.ng.bluemix.net/docs/starters/wordpress/index.html#faq__UsingComposerToManageYourWordPressA)
3.  When your app modifications are done, use the cloud foundry command-line tool to push your app:
    1.  If you do not have the command-line tool (cf), see [Start coding with Cloud Foundry command line interface](https://www.ng.bluemix.net/docs/starters/install_cli.html).
    2.  Deploy your app to Bluemix by running cf push from the root directory of your application. If you updated WordPress Core, you might need to update your database.
4.  Your app is now available at http://.mybluemix.net.
5.  Everytime the app is restaged, there is a possibility that the WordPress core has been updated. This depends on how the WordPress version is set in the composer.json file. The default is to get the latest version.
    1.  After WorPress core receives an update, you may need to apply changes to the database. WordPress is able to detect this and prompts the user to run a database update. The prompt appears in the admin console after log in. If the login page does not appear, it can be found at .mybluemix.net/wp-login.php.

# FAQ
## What is IBM Object Storage and what is it being used for?
IBM Object Storage is a service that uses SoftLayer Object Storage, which is SoftLayer's implementation of OpenStack Swift.
IBM Object Storage is useful because WordPress traditionally relies on the local file system for things like media uploads. Since Bluemix, like every other cloud platform, uses an ephemeral file system, this action would result in losing your files every time that you push or restart your Bluemix app. With IBM Object Storage, files are uploaded to Swift and stored on the internet so that they are never left out. The SoftLayer Swift plugin within WordPress provides an admin settings page so that you can manage your containers and your upload options.
## What is Sendgrid and what is it being used for?
Sendgrid is an easy to use email service that is integrated into WordPress on Bluemix. Using the Sendgrid service enables your WordPress website to send emails for things like forgotten passwords or comment notifications. With Wordpress on Bluemix, everything's configured to work out of the box with no tedious work to setup email server configurations.
## How do I manage my containers in IBM Object Storage?
Object Storage uses containers to create a pseudo-filesystem on your object storage account. To set the container, go to your Swift settings page in the Admin pane. Then, click Select a container, and choose Create a Container. Specify the name of your container, and click Ok. When you upload an image to WordPress, Wordpress uploads the image to your Object Storage container. If you upload media before you specify the container to send it to, WordPress uses the default "WordPress" container.
## What plugins are being used in the default installation?
*   Disable Updates Manager: As Bluemix does not use a persistent file system, using the automatic update buttons in the WordPress UI would cause updates and plugins that you install to disappear after your app restarts. The Disable Updates Manager hides the update notifications for WordPress Core, plugins, and themes by default. You are welcome to change this setting, but keep in mind that all updates to your WordPress installation are handled by downloading your code and pushing again with the cf command.
*   Sendgrid: Sendgrid provides email integration with your website. Activate the Sendgrid Bluemix plugin to automatically use Bluemix credentials to use Sendgrid, or provide your own.
*   Object Storage: Handle all media storage and uploads for your WordPress site.
*   WP Super Cache: A popular WordPress optimization plugin that uses caching to speed up your blog.

## WP Super Cache Plugin
1.  Navigate to the plugins page in the admin dashboard.
2.  Find the WP Super Cache plugin in the list.
3.  Click Activate.
4.  A message at the top of the page says, "WP Super Cache is disabled. Please go to the plugin admin page to enable caching." Click on the plugin admin page.
5.  If you are directed to a page that says, "Permalink Structure Error", a custom URL or permalink structure is required for the plugin to work correctly. Go to the Permalinks Options Page to configure the permalinks. Click the Permalinks Options Page link and choose a new permalink structure. Hit Save Changes. A common choice here is month and name.
6.  Navigate to the WP Super Cache settings under the Settings Tab. Turn caching on. Hit Update Status.
You are now using caching.

## My WordPress site received an "Error establishing a database connection" message.
You probably have too many concurrent users who are trying to access your website. By default, WordPress on Bluemix uses the free tier of ClearDB's MySQL database as a service that is suitable for trial usage. However, for real usage, consider upgrading to one of their paid tiers, which provide you with more simultaneous connections and more storage space. Unfortunately, paid tiers for ClearDB are not offered in Bluemix currently. Contact ClearDB support for options on upgrading your plan. You can also try activating the [WP Super Cache Plugin](https://www.ng.bluemix.net/docs/starters/wordpress/index.html#faq__WPSuperCache) to improve performance.
## My site is loading slowly. Can I speed it up?
Bluemix provides built-in support for scaling your apps. Increase the number of instances from 1 to however many needed (start with 2) until response times improve. You can also try activating the [WP Super Cache Plugin](https://www.ng.bluemix.net/docs/starters/wordpress/index.html#faq__WPSuperCache) to improve performance.
## I received an HTTP error when I tried to upload an image.
Either the IBM Object Storage service is down, or SoftLayer itself is down. If you provisioned your WordPress application, it's possible that your SoftLayer account is not created yet. Usually this problem resolves itself within several minutes.
## Using Composer to manage your WordPress application.
The boilerplate uses the PHP dependency manager Composer to dynamically install your plugins and themes. You can manage all plugins, even the WordPress core version, by modifying the composer.json file.
*   Open the composer.json file. Under the required section, you enter the information for what is being added. There is a specific composer vendor, wpackagist, that mirrors WordPress' SVN repositories for both plugins and themes. This creates a simple way to add more plugins and themes.
    *   If you want to specify a version of WordPress, you can change the following line: "johnpbloch/wordpress" : "*". The "*" can be replaced with your desired version number. For more information about the version notation, see [package versions](https://getcomposer.org/doc/01-basic-usage.md#package-versions "(Opens in a new tab or window)").
    *   If you are adding a plugin, the vendor name is wpackagist-plugin. The package name is whatever the plugin developer registered their plugin as. If you want to install a plugin that is called hello-world, then add wpackagist-plugin/hello-world in the require section.
    *   Adding a theme follows a similar model, but the vendor name is wpackagist-theme
    *   After that, specify a version number. You can use * to grab the most up-to-date version of a plugin. For themes, use the * in all cases.
    Example:
    `"wpackagist-plugin/hello-world"			: "*"
    "wpackagist-theme/twentytwelve			: "*"`
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
} ```
3. Finally, we need to tell composer where to place this privately sourced plugin folder.  Modify this projects composer.json within the post-install-cmd array to include a command for **moving** your private plugin content to the wp-content plugins folder.  The command will look similar to this:

   ```"mv lib/my-personal-plugin-folder htdocs/wp-content/plugins"```    

## Routes to my posts and pages start failing unexpectedly
The .htaccess is a distributed config file.  Wordpress uses this file to manipulate how Apache serves files from its root directory and subdirectories thereof.  Most notably, WP modifies this file to be able to handle pretty permalinks. An example of a default version can be found [here](https://codex.wordpress.org/htaccess) . If your routes unexpectedly stop working until you reset your permalinks settings within the Admin dashboard, then you are most likely dealing with a .htaccess file that is either corrupt or being deleted after app restart.  Use the **cf files** or the Bluemix dashboard to inspect the .htaccess file which should be present at */app/htdocs/.htaccess*.  Visit the **lib** folder of this repository and update the .htaccess default file provided in this repo.  
## Object Storage HTTP Error: A field name was provided without a field value
When a WordPress instance is started for the first time, the boilerplate creates an Object Storage subaccount for the application to use. This process can take anywhere from 30 seconds to 10 minutes. This is the error that you see when it is not completed before you go to the Object Storage settings of your site. Try again in a minute and it might be working properly. If you are seeing this error and it is not the first time you've started the boilerplate, it might mean that the IBM Object Storage service is down.
## Can I upload files larger than 500 MB?
This value, along with several others, is defined in the .user.ini file in the root directory. You can change the value to anything you like, but keep in mind that the default disk quota in a Bluemix app is 1 GB, and it can be a maximum of 2 GB.
