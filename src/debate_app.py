import os
from dotenv import load_dotenv
load_dotenv()

from typing import List, Literal, cast
from baml_client import b  # auto-generated client
from baml_client.types import DebateMessage, DebateTopic

DebateRole = Literal['panelist_a', 'panelist_b', 'panelist_c', 'moderator']

class DebateApp:
    def __init__(self, topic: DebateTopic):
        self.topic = topic
        self.debate_history: List[DebateMessage] = []
        
    def add_message(self, role: DebateRole, content: str) -> None:
        speaker_map = {
            'panelist_a': 'Peter Thiel',
            'panelist_b': 'Eric Schmidt',
            'panelist_c': 'Sam Harris',
            'moderator': 'Joe Rogan'
        }
        speaker_name = speaker_map[role]
        message = DebateMessage(
            role=role,
            content=content,
            speaker_name=speaker_name
        )
        self.debate_history.append(message)
        # Print each message as it's added with clear formatting
        print(f"\n{speaker_name}:")
        print(content.strip())
        print("\n" + "-" * 80)

    def get_panelist_response(self, panelist_role: DebateRole) -> str:
        panelist_functions = {
            'panelist_a': b.PanelistA,
            'panelist_b': b.PanelistB,
            'panelist_c': b.PanelistC
        }
        response = panelist_functions[panelist_role](
            topic=self.topic,
            debate_history=self.debate_history
        )
        return response

    def get_moderator_response(self) -> str:
        response = b.Moderator(
            topic=self.topic,
            debate_history=self.debate_history
        )
        return response

    def run_debate(self) -> None:
        print("\n=== Starting AI Panel Debate ===\n")
        print(f"Topic: {self.topic.title}")
        print(f"Description: {self.topic.description}")
        print("\n" + "=" * 80)

        # Opening statement and question from moderator
        opening = self.get_moderator_response()
        self.add_message(cast(DebateRole, "moderator"), opening)

        # Main debate rounds
        panelist_roles: List[DebateRole] = ['panelist_a', 'panelist_b', 'panelist_c']
        
        for round_num in range(1, 4):
            print(f"\n=== Round {round_num} ===")
            
            # Get responses from each panelist for the moderator's question
            for role in panelist_roles:
                response = self.get_panelist_response(role)
                self.add_message(role, response)
            
            # Moderator summarizes and poses next question
            if round_num < 3:  # Don't get new question after final round
                mod_response = self.get_moderator_response()
                self.add_message(cast(DebateRole, "moderator"), mod_response)

        # Final synthesis round
        print("\n=== Final Synthesis ===")
        
        # Moderator asks for final thoughts
        final_prompt = self.get_moderator_response()
        self.add_message(cast(DebateRole, "moderator"), final_prompt)

        # Final statements from panelists
        for role in panelist_roles:
            response = self.get_panelist_response(role)
            self.add_message(role, response)

        # Closing remarks from moderator
        closing = self.get_moderator_response()
        self.add_message(cast(DebateRole, "moderator"), closing)

def main():
    topic = DebateTopic(
        title="Is College Worth It?",
        description="Discussing the value of a college education"
    )
    
    debate = DebateApp(topic)
    debate.run_debate()

if __name__ == "__main__":
    main() 