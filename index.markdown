---
layout: default
title: FbFriends
---

FbFriends
=========

FbFriends is a jQuery plugin for picking Facebook friends from a dialog.

<button class="btn btn-primary basic-button">Try it!</button>

##The Basics

###Requirements

 * [jQuery](http://jquery.com)
 * A reference to the [FB SDK JS](http://connect.facebook.net/en_US/all.js)
 * The FbFrinds [JS file](files/fbfriends.js) and modifiable [CSS file](files/fbFriends.css) 
 * The CSS references a [loading animation](css/ajax-loader.gif) which you may or may not want
 * Some kind of JS library for providing a dialog, such as [Bootstrap](http://twitter.github.com/bootstrap/) or
   [jQuery UI](jqueryui.com)

IOW:

{% highlight html %}
<script type='text/javascript' src='http://code.jquery.com/jquery-1.8.0.min.js'></script>
<script type='text/javascript' src='http://connect.facebook.net/en_US/all.js'></script>

<script type='text/javascript' src='files/fbfriends.js'></script>
<link rel='stylesheet' type='text/css' href='files/fbFriends.css'/>

<!-- or similar -->
<script type='text/javascript' src='js/bootstrap.min.js'></script>
<link rel='stylesheet' type='text/css' href='css/bootstrap.min.css'/>
{% endhighlight %}

###Basic Usage

Put a div into a section of the DOM that we can create a dialog out
of. In this example I'm using Bootstrap's Modal, though anything will do
(see the BYOD section below).

{% highlight html %}
<div class="modal hide" role="dialog">
  <div class="modal-header">
    <button class="close" data-dismiss="modal" type="button" aria-hidden="true">&times;</button>
    <h3>Select a Friend</h3>
  </div>
  <div class="modal-body">
    <!-- This is the important bit -->
    <div id="basic"></div>
  </div>
</div>
{% endhighlight %}

Then we call our plugin, passing functions to control the dialog and
handle the user's section:

{% highlight js %}
$("#basic").fbFriends({
  whenDone: function(friends){ doSomethingWithArray(friends);},
  shower: function(element){ element.parents(".modal").modal("show");},
  hider: function(element){ element.parents(".modal").modal("hide");},
});
{% endhighlight %}

And here it is in action, with the JS above bound to a button, and with
the `whenDone` callback set to show cool toaster things:

<button class="btn basic-button">Choose a Friend</button>

That's it! (Although I have styled the modal a [bit](/css/demo.css).)

### Friends objects

The whenDone callback takes an array of friend objects, which are passed
directly back from the FB API. They might looks something like this:


{% highlight js %}
[
  {
    first_name: "Bob",
    last_name: "Dole",
    id: "11111",
    name: "Bob Dole",
    picture: {
      data: {
        is_silhouette: false,
        url: "http://someImageUrl"
      }
    }
  }
]
{% endhighlight %}

Those are the fields that come back by default. If you want more info
about the friend(s), you can specify a list of fields in the
`additionalFields` option, like so:

{% highlight js %}
$("#something").fbFriends({
  additionalFields: ["gender"],
  afterDone: function(friends){ console.log(friends[0].gender);}
});
{% endhighlight %}


You should first try the fields out in the [FB API Graph
Explorer](https://developers.facebook.com/tools/explorer/?method=GET&path=me%2Ffriends%3Ffields%3Dname%2Cid%2Cpicture%2Cfirst_name%2Clast_name) to see how if how it works (e.g. do you need to configure your app to ask for more permissions?).

##Bring Your Own Dialog (BYOD)

FbFriends doesn't contain any functionality for creating a dialog. You
just put the FbFriends root inside of your favorite Javascript-controlled dialog and pass FbFriends
functions to open and close it. That way, you can use anything you want:
Bootstrap's modal, JQueryUI dialog, even nothing at all. This allows
FbFriends to be very flexible; you can control all the parameters of
your dialog, theme it, etc.

For example, you could also easy [jQuery UI](http://jqueryui.com/) with a default theme like this:

{% highlight html %}
<div title="Select a friend">
  <div id="jqueryui"/>
</div>
{% endhighlight %}

{% highlight js %}
$("#jqueryui").fbFriends({
  whenDone: toast,
  shower: function(element){ element.parent().dialog({ height: 400, width: 400 });},
  hider: function(element){ element.parent().dialog("close");}
});
{% endhighlight %}

And here it is in action:

<button class="btn" id="jqueryui-button">jQuery UI Dialog</button>

##Single or Multi Selection

By default, FbFriends lets the user pick a single friend with a click
and then closes the dialog. But you can also allow them to check
multiple friends by passing the `multiple: true` parameter. A few
options matter here:

{% highlight js %}
$("#multi").fbFriends({
  multiple: true,
  whenDone: function(friends){//do something with the whole array of selected freinds},
  friendChecked: function(friend){//optional, do something on check},
  friendUnchecked: function(friend){//optional, do something on uncheck},

  //normal dialog stuff
  shower: function(element){ element.parents(".modal").modal("show");},
  hider: function(element){ element.parents(".modal").modal("hide");},
});
{% endhighlight %}

We add a couple of buttons to our modal so that the user can tell us
when they're done:

{% highlight html %}
<div class="modal-footer"> 
  <button class="btn" data-dismiss="modal" aria-hidden="true">Cancel</div>
  <button id="multi-submit" class="btn btn-primary">Done</button>
</div>
{% endhighlight %}

We also need to provide bind the "Done" button so that it informs
FbFriends that the user is done selecting people:

{% highlight js %}
$("#multi-submit").done(function(){
  $("#multi").fbFriends("submit");
});
{% endhighlight %}

Do it:

<button class="btn multi-button">Multiselect</button>

##Opening and closing the dialog

By default, FbFriends will open the dialog as soon as it's called. You
can override that by passing `immediate: false` in the options. You can
later open the dialog with:

{% highlight js %}
$(yourSelector).fbFriends("show");
{% endhighlight %}

You can also programmatically close it:

{% highlight js %}
$(yourSelector).fbFriends("hide");
{% endhighlight %}

##FB Initialization and Login

By default, FbDialog assumes you've already initialized the FB
Javascript SDK and logged in the user. But if you don't need to use the
FB SDK outside of showing FbFriends, you can have FbFriends do all the
work for you. You'll need to pass it at least an FB appID:

{% highlight js %}
$("#yourDiv").fbDialog({
  //other options here
  initialize: true,
  login: true,
  fb: {
    appId: "your FB app ID",
    //other optional settings
  }
});
{% endhighlight %}

The entire `fb` value gets passed to [FB.init](https://developers.facebook.com/docs/reference/javascript/FB.init/) so use it however you need. 

You can also decide whether you want FbFriends to try to log in the
user. By default, it will. Redundant logins are harmless but take some
extra time. You can make FbFriends assume the user is logged in by
specifying `login: false`.

You can specify `afterLogin` to get FB's successful response to
authentication by specifying the `afterLogin` function. That's useful if
you need to capture the name and FB ID of the user.

`initialize: true` implies `login: true` but not vice-versa.

##Full Options Documentation

Here's the full set of options with defaults:

{% highlight js %}
$("#yourDiv").fbDialog({
{
  multiple: false,                //select mutliple friends
  whenDone: function(friends) {   //callback when selection is done
    return console.log(friends);
  },
  friendChecked: null,            //in multiple mode, callback for when a friend is checked
  friendUnchecked: null,          //in multiple mode, callback for when a friend is unchecked
  shower: function(element) {},   //how to show the dialog
  hider: function(element) {},    //how to hide the dialog
  immediate: true,                //show the dialog imediately
  initialize: false,              //whether to handle the FB SDK initialization internally
  login: true,                    //whether to log the user into FB if required
  fb: {                           //options past to FB.init if initialize is true
    appId: null,
    channelUrl: null,
    status: true,
    cookie: true,
    xfbml: false
  },
  afterLogin: null,                //callback with the users info if login: true
  additionalFields: []
});
{% endhighlight %}

<div class="modal hide" role="dialog">
  <div class="modal-header">
    <button class="close" data-dismiss="modal" type="button" aria-hidden= "true">&times;</button>
    <h3>Select a Friend</h3>
  </div>
  <div class="modal-body">
    <div id="basic"></div>
  </div>
</div>

<div class="modal hide" role="dialog">
  <div class="modal-header">
    <button class="close" data-dismiss="modal" type="button" aria-hidden= "true">&times;</button>
    <h3>Select Some Friends</h3>
  </div>
  <div class="modal-body">
    <div id="multi"></div>
  </div>
  <div class="modal-footer"> 
    <button class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>
    <button id="multi-submit" class="btn btn-primary">Done</button>
  </div>
</div>

<div title="Select a friend">
  <div id="jqueryui"/>
</div>
