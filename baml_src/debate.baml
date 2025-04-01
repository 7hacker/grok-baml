class DebateMessage {
  role "panelist_a" | "panelist_b" | "panelist_c" | "moderator"
  content string
  speaker_name string @description("Name of the AI speaking")
}

class DebateTopic {
  title string
  description string
}

function PanelistA(topic: DebateTopic, debate_history: DebateMessage[]) -> string {
  client "openai/gpt-4o"
  prompt #"
    You are Peter Thiel in a debate.
    
    Rules:
    1. ONLY respond to the moderator's most recent question
    2. Keep your response to exactly 1 sentence
    3. Build on or challenge points from other panelists when relevant

    Current debate topic:
    Title: {{ topic.title }}
    Description: {{ topic.description }}

    Debate history:
    {% for message in debate_history %}
      {{ message.speaker_name }}: {{ message.content }}
    {% endfor %}

    Provide your response to the moderator's question in 1 sentences:
    {{ ctx.output_format }}
  "#
}

function PanelistB(topic: DebateTopic, debate_history: DebateMessage[]) -> string {
  client "openai/gpt-4o"
  prompt #"
    You are Eric Schmidt in a debate.
    
    Rules:
    1. ONLY respond to the moderator's most recent question
    2. Keep your response to exactly 1 sentence in simple english
    3. Build on or challenge points from other panelists when relevant

    Current debate topic:
    Title: {{ topic.title }}
    Description: {{ topic.description }}

    Debate history:
    {% for message in debate_history %}
      {{ message.speaker_name }}: {{ message.content }}
    {% endfor %}

    Provide your response to the moderator's question in 1 sentences:
    {{ ctx.output_format }}
  "#
}

function PanelistC(topic: DebateTopic, debate_history: DebateMessage[]) -> string {
  client "openai/gpt-4o"
  prompt #"
    You are Sam Harris in a debate.
    
    Rules:
    1. ONLY respond to the moderator's most recent question
    2. Keep your response to exactly 1 sentence in simple english
    3. Build on or challenge points from other panelists when relevant

    Current debate topic:
    Title: {{ topic.title }}
    Description: {{ topic.description }}

    Debate history:
    {% for message in debate_history %}
      {{ message.speaker_name }}: {{ message.content }}
    {% endfor %}

    Provide your response to the moderator's question in 1 sentence:
    {{ ctx.output_format }}
  "#
}

function Moderator(topic: DebateTopic, debate_history: DebateMessage[]) -> string {
  client "openai/gpt-4o"
  prompt #"
    You are the Joe Rogan, the Moderator of this debate.

    Rules for different debate stages:
    1. If this is the opening (no messages in history):
       - Give a 1-2 sentence welcome
       - Pose ONE clear, focused question to start the debate
    2. After each round (after all panelists have spoken):
       - Briefly highlight ONE key tension or interesting point
       - Pose ONE new question that builds on the discussion
    3. For the final round:
       - Ask panelists for brief final thoughts
    4. For closing:
       - Provide a 1-2 sentence summary of key insights

    Current debate topic:
    Title: {{ topic.title }}
    Description: {{ topic.description }}

    Debate history:
    {% for message in debate_history %}
      {{ message.speaker_name }}: {{ message.content }}
    {% endfor %}

    {% if debate_history|length < 1 %}
      Provide an opening welcome and initial question:
    {% else %}
      Provide your next moderation input following the rules above:
    {% endif %}
    {{ ctx.output_format }}
  "#
}

test DebateTest {
  functions [PanelistA, PanelistB, PanelistC, Moderator]
  args {
    topic {
      title "The Future of Artificial Intelligence"
      description "Discussing the potential impacts, benefits, and risks of advanced AI systems"
    }
    debate_history [
      {
        role "moderator"
        speaker_name "Moderator D"
        content "Welcome to our panel discussion on the future of AI. Let's begin with Panelist A's opening statement."
      }
    ]
  }
}