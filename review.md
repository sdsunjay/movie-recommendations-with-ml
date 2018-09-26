# Code Review

Code review for #1

## Overview
The current functionality so far is that the user can sign up for an account using their Facebook profile. Upon sign up, the application will automatically grab the user's friends that are currently using the application and store them in the Friendship table. The user cannot view their friends (yet). The application will also get a list of movies the user has liked from Facebook and add the user's positive review to the Review table. Once successfully signed up, the user can review movies in the all movies page or click the movie poster to see more detailed information. Users can view movies by genre by selecting the genre in the navigation bar. Users can view information about themselves and the movies they have reviewed by clicking the 'Account' link in the navbar. Users can edit or delete their review at any time. User can also search for a movie in the database. <br>
While the majority of users are normal users, some users are *admin* or *super_admin* users, giving them additional permissions. These users can create new movies and edit/delete exisiting movies. They can also view reviews of all users and edit/delete them. They can also view all genres and edit/delete them. They can also view all users. They can also view all friendships and edit/delete them.

## Technical Details
* Sign In/Sign Up
  * In the navbar there is a sign up and sign in link, currently these links direct to the same page, but we would like to redirect to different pages. How can we do this?
    * This has been difficult because we are not utilizing Devise Registration as all registration is done with Facebook.
  * When the user signs up, we want to grab their friends and movies. We don't want to do this when the user is simply logging in. It has been suggested that I utilize *intents*, but I have been unable to pass the intent to the omniauth controller. See app/views/devise/sessions/new.html.erb.
    * In the future, we will utilize the Facebook Graph API to reach out to the application and update the user's friends

* Facebook API
  * Using the Koala gem, we get the user's friends from the [Facebook API](https://developers.facebook.com/docs/graph-api/reference/user/friends/). However, we only get the first page of their friends. We need to iterate through all their friends by iterating through all the pages returned by the API. The same is true for when we get the user's movies.
  * The Facebook API gives us a token, which we store. We will also store the expiration date of that token, but when/how do we update it?
  * Please look at app/models/user.rb, specifically add_friends and add_movies as these functions need help

* Performance
  * When the user is viewing the all movies page, they see the text, *Reviewed* under the movies that have already been reviewed. However, we would prefer they see their rating (thumbs up or thumbs down) when they are looking at a movie they have already reviewed, but how can we
  do that?
  * When determining if a movie has been reviewed, we do so for each individual movie on the page. However, it would be better if we checked if the movie was in the movies a user has reviewed. How can we do that?

## Specific Files
  Please revie the following specific files
* [app/models/user.rb](app/models/user.rb)
* [app/controllers/application_controller.rb](app/controllers/application_controller.rb)
* [app/controllers/movies_controller.rb](app/controllers/movies_controller.rb)
* [app/controllers/users_controller.rb](app/controllers/users_controller.rb)
* [app/views/devise/sessions/new.html](app/views/devise/sessions/new.html)
* [app/views/partials/_movies.html.erb](app/views/partials/_movies.html.erb)
