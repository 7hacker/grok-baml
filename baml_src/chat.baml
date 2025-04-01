class MyUserMessage {
  role "user" | "assistant"
  content string
}

function ChatWithLLM(messages: MyUserMessage[]) -> string {
  client "openai/gpt-4o"
  prompt #"
    Answer the user's questions based on the chat history:
    {% for message in messages %}
      {{ _.role(message.role) }} 
      {{ message.content }}
    {% endfor %}

    Answer:
  "#
}


test TestName {
  functions [ChatWithLLM]
  args {
    messages [
      {
        role "assistant"
        content "Hello!"
      }
      {
        role "user"
        content "Hello!"
      }
    ]
  }
}

