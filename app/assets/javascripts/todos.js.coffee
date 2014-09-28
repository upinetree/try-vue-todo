$ ->
  todo = Vue.extend
    template:'#todo-template'

    data:
      isTitleEditing: false
      editingTarget: ''
      editingValue: ''

    methods:
      editTitle: ->
        @isTitleEditing = true
        @editingTarget = 'title'
        @editingValue = @title # フィールドの初期値として現在の値を入れる
        setTimeout =>
          $('input', @$el).focus()
        , 50

      update: ->
        @isTitleEditing = false

        _todo = {}
        _todo[@editingTarget] = @editingValue

        $.ajax
          type: 'POST'
          url: @url
          data:
            _method: 'PATCH'
            todo: _todo
          success: (response) =>
            if (response.errors)
              alert '更新に失敗しました\n' + response.errors.join('\n')
            else
              @title = response.todo.title
          error: (response) =>
            alert '更新に失敗しました（通信エラー）'

      destroy: ->
        return unless confirm('削除しても良いですか？')
        $.ajax
          type: 'DELETE'
          url: @url
          success: =>
            @$destroy()
          error: =>
            alert '削除に失敗しました（通信エラー）'

  new Vue
    el: '#vue-todos'

    paramAttributes: ['todosUrl']

    data:
      todos: []
      newTodo: ''

    components:
      todo: todo

    created: ->
      $.getJSON @todosUrl, (response) =>
        @todos = response.todos

    methods:
      createTodo: ->
        $.ajax
          type: 'POST'
          url:  @todosUrl
          data: { todo: { title: @newTodo } }
          success: (response) =>
            if (response.errors)
              alert '作成に失敗しました\n' + response.errors.join('\n')
            else
              @todos.push(response.todo)
          error: (response) =>
            alert '作成に失敗しました（通信エラー）'
        @newTodo = ''

      destroyTodo: (todo) ->
        todo.destroy()
        @todos.$remove(todo.$data)

