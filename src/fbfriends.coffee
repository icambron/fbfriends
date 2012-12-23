do (jQuery) ->
  $ = jQuery

  fields = ['name', 'id', 'picture', 'first_name', 'last_name']

  defaults =

    #select mutliple friends or just one
    multiple: false

    #FbFriend will call this function when the user finishes selecting their friend(s). Takes an array of friends.
    whenDone: null

    #if you multiselect, FbFriend will call this function when a friend is checked. Takes a friend object.
    friendChecked: null

    #if you multiselect, FbFriend will call this function when a friend is unchecked. Takes a friend object.
    friendUnchecked: null

    shower: (element) => throw 'You need to supply your own dialog'
    hider: (element) => throw 'You need to supply your own dialog'

    #open the dialog right away
    immediate: false

    #let FbFriends handle the API initialization for you.
    initialize: true,

    #let FbFriends show a login dialog if necessary. If false, FBFriends will assume the user is logged in.
    login: true

    #parameters to pass 
    fb:
      appId: null,
      channelUrl: null,
      status: true,
      cookie: true,
      xfbml: false

    #function to call if FbFriends logs in for you. Takes (err, authResponse)
    afterLogin: null

  class FbFriends
    constructor: (element, @options) ->
      @element = $ element
      @afterLogin = @options.afterLogin
      @element.data 'fbFriends', @
      @element.addClass 'fbFriends'

      @element.on 'click', '.fbFriends-friend', (event) => @handleClick event.target

    show: ->
      @initialize (err) =>
        #not sure what error conditions are really possible here...
        @selected = {}
        @login (err) =>
          @options.shower(@element)
          @element.empty()

          header = $('<div>')
            .addClass('fbFriends-header')
            .appendTo @element

          $('<input>')
            .attr('type', 'text')
            .attr('placeholder', 'Search')
            .addClass('fbFriends-search')
            .keyup((event) =>
              friends = $('.fbFriends-friend', @element)
              text = $(event.target).val().toLowerCase()
              if text == ''
                friends.show()
              else
                matched = friends.filter("[data-first-name^='#{text}'], [data-last-name^='#{text}']")
                matched.show()
                friends.not(matched).hide()
            )
            .appendTo header

          ajaxLoader = $('<div>')
            .addClass('fbFriends-spinner')
            .appendTo(@element)

          if err
            $('<div>')
              .addClass('fbFriends-error')
              .text("There's been an error processing your login. Please make sure you're logged into Facebook and try again.")
              .appendTo @element
          else
            processResponse = (response) =>
              ajaxLoader.hide()

              if response.error
                $('<div>')
                  .addClass('fbFriends-error')
                  .text("There's been an error retrieving your friends. Please reload the page and try again.")
                  .appendTo @element
              else
                @element.toggleClass 'single', @options.single
                @element.toggleClass 'multiple', !@options.single

                response.data.forEach (friend) =>
                  friendDiv = $('<div>').addClass('fbFriends-friend')

                  $('<input>').attr('type', 'checkbox').appendTo(friendDiv) if @options.multiple
                  $('<img>').attr('src', friend.picture.data.url).appendTo friendDiv
                  $('<span>').addClass('fbFriends-name').text(friend.name).appendTo friendDiv

                  friendDiv
                    .data('id', friend.id)
                    .data('name', friend.name)
                    .data('picture', friend.picture.data.url)
                    .attr('data-first-name', friend.first_name.toLowerCase())
                    .attr('data-last-name', friend.last_name.toLowerCase())

                  @element.append friendDiv

                if response.paging && response.paging.next
                  FB.api response.paging.next, processResponse

            FB.api "/me/friends?fields=#{fields.join ','}", processResponse

    cancel: -> @options.hider()

    submit: ->
      if @options.multiple
        @options.whenDone (val for key, val of @selected)
        @options.hider()

    handleClick: (item) ->
      $item = $ item
      data =
        id: $item.data 'id'
        name: $item.data 'name'
        picture: $item.data 'picture'

      if @options.multiple
        if @selected[data.id]
          delete @selected[data.id]
          $(item).find("input[type=checkbox]").attr('checked', false)
          @options.friendUnchecked data if @options.friendUnchecked
        else
          @selected[data.id] = data
          $(item).find("input[type=checkbox]").attr('checked', true)
          @options.friendChecked data if @options.friendChecked
      else
        @options.whenDone [data]
        @options.hider()

    initialize: (after) ->
      if @options.initialize && !@initialized
        @initialized = true

        FB.Event.subscribe 'auth.statusChange', (response) =>
          @loggedIn = response.status == 'connected'
          err = if @loggedIn then null else 'Login failure'
          @afterLogin err, response.authResponse if @afterLogin

        FB.init @options.fb

        if @options.fb.status
          FB.getLoginStatus (response) -> after()
        else after()
      else after()

    login: (after) ->
      if @options.login && !@loggedIn
        FB.login (response) =>
          if response.authResponse && response.status == 'connected'
            @loggedIn = true
            after()
          else
            err = "User didn't log in."
            @afterLogin err if @afterLogin
            after err
      else 
        @loggedIn = true
        after()

    logout: -> 
      if @loggedIn
        @loggedIn = false
        FB.logout()

  #plugin
  $.fn.fbFriends = (input) ->
    @each ->
      $this = $ @
      fbFriends = $this.data 'fbFriends'
      unless fbFriends
        options = if typeof(input) == 'object' then $.extend(true, {}, defaults, input) else defaults
        fbFriends = new FbFriends($this, options)
        fbFriends.show() if options.immediate
      if typeof input == 'string'
        fbFriends[input]()
