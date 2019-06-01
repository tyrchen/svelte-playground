<script>
  import { onMount } from "svelte";
  import { fade } from "svelte/transition";

  const ENTER_KEY = 13;
  const ESC_KEY = 27;

  let currentFilter = "all";
  let newTodo = "";
  let curId = 2;
  let curTitle = "";
  let quote = "";

  let todos = [
    {
      id: 1,
      title: "go for shopping",
      completed: false,
      editing: false
    }
  ];

  function addTodo(event) {
    if (event.which === ENTER_KEY) {
      todos.push({
        id: curId,
        completed: false,
        title: newTodo,
        editing: false
      });
      todos = todos;
      newTodo = "";
      curId = curId + 1;
    }
  }

  function editTodo(todo) {
    todo.editing = true;
    curTitle = todo.title;
    todos = todos;
  }

  function doneEdit(todo, commit) {
    todo.editing = false;
    if (commit) todo.title = curTitle;
    todos = todos;
  }

  function doneEditKeyDown(todo, event) {
    switch (event.which) {
      case ENTER_KEY:
        return doneEdit(todo, true);
      case ESC_KEY:
        return doneEdit(todo, false);
      default:
        return;
    }
  }

  function deleteTodo(id) {
    todos = todos.filter(todo => todo.id !== id);
  }

  function checkAllTodos(event) {
    todos = todos.map(todo => {
      todo.completed = event.target.checked;
      return todo;
    });
  }

  function clearCompleted() {
    todos = todos.filter(todo => !todo.completed);
  }

  function updateFilter(filter) {
    currentFilter = filter;
  }
  onMount(async () => {
    const res = await fetch("https://api.kanye.rest");
    const response = await res.json();
    quote = response.quote;
  });
  $: todosRemaining = todos.filter(todo => !todo.completed).length;

  $: filteredTodos = (() => {
    console.log(currentFilter);
    switch (currentFilter) {
      case "completed":
        return todos.filter(todo => todo.completed);
      case "active":
        return todos.filter(todo => !todo.completed);
      default:
        return todos;
    }
  })();
</script>

<style lang="scss">
  .container {
    max-width: 600px;
    margin: 0 auto;
  }
  .logo {
    display: block;
    margin: 20px auto;
    height: 75px;
  }
  .quote {
    display: block;
    font-size: 20px;
    padding: 15px;
    text-align: center;
  }

  .todo-input {
    width: 100%;
    padding: 10px 18px;
    font-size: 18px;
    margin-bottom: 16px;
  }
  .todo-item {
    margin-bottom: 12px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    animation-duration: 0.3s;
  }
  .remove-item {
    cursor: pointer;
    margin-left: 14px;
    &:hover {
      color: red;
    }
  }
  .todo-item-left {
    // later
    display: flex;
    align-items: center;
  }
  .todo-item-label {
    padding: 10px;
    border: 1px solid white;
    margin-left: 12px;
  }
  .todo-item-edit {
    font-size: 24px;
    color: #2c3e50;
    margin-left: 12px;
    width: 100%;
    padding: 10px;
    border: 1px solid #ccc; //override defaults
    font-family: "Avenir", Helvetica, Arial, sans-serif;
    &:focus {
      outline: none;
    }
  }
  .completed {
    text-decoration: line-through;
    color: grey;
  }
  .extra-container {
    display: flex;
    align-items: center;
    justify-content: space-between;
    font-size: 16px;
    border-top: 1px solid lightgrey;
    padding-top: 14px;
    margin-bottom: 14px;

    input {
      margin-right: 8px;
    }
  }
  button {
    font-size: 14px;
    background-color: white;
    appearance: none;
    cursor: pointer;
    &:hover {
      background: salmon;
    }
    &:focus {
      outline: none;
    }
  }
  .active {
    background: salmon;
  }
</style>

<div class="container">
  <img src={'/img/svelte-logo-horizontal.svg'} alt="svelte logo" class="logo" />
  <p class="quote">{quote}</p>
  <input
    type="text"
    class="todo-input"
    placeholder="What needs to be done"
    bind:value={newTodo}
    on:keydown={addTodo} />

  {#each filteredTodos as todo}
    <div class="todo-item">
      <div class="todo-item-left" transition:fade>
        <input type="checkbox" bind:checked={todo.completed} />
        {#if !todo.editing}
          <div
            class="todo-item-label"
            class:completed={todo.completed}
            on:dblclick={() => editTodo(todo)}>
             {todo.title}
          </div>
        {:else}
          <input
            class="todo-item-edit"
            bind:value={curTitle}
            type="text"
            on:keydown={event => doneEditKeyDown(todo, event)}
            autofocus />
        {/if}
      </div>
      <div class="remove-item" on:click={() => deleteTodo(todo.id)}>×</div>
    </div>
  {/each}

  <div class="extra-container">
    <div>
      <label>
        <input type="checkbox" on:change={checkAllTodos} />
        Check All
      </label>
    </div>
    <div>{todosRemaining} items left</div>
  </div>

  <div class="extra-container">
    <div>
      <button
        class:active={currentFilter === 'all'}
        on:click={() => updateFilter('all')}>
        All
      </button>
      <button
        class:active={currentFilter === 'active'}
        on:click={() => updateFilter('active')}>
        Active
      </button>
      <button
        class:active={currentFilter === 'completed'}
        on:click={() => updateFilter('completed')}>
        Completed
      </button>
    </div>

    <div>
      <button on:click={clearCompleted}>Clear Completed</button>
    </div>
  </div>

</div>
