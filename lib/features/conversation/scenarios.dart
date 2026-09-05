import 'apple_intelligence.dart';

class ConversationScenario {
  const ConversationScenario(
    this.id,
    this.title,
    this.setting,
    this.goal,
    this.questions,
    this.twist,
  );
  final String id, title, setting, goal, twist;
  final List<String> questions;
}

const conversationScenarios = [
  ConversationScenario(
    'introductions',
    'Meeting someone new',
    'A relaxed community gathering. You and a new acquaintance have just made eye contact.',
    'Introduce yourself and discover one shared interest.',
    [
      'What would you like this person to know about you?',
      'How will you invite them to share something about themselves?',
      'You miss their name. How can you repair the exchange?',
    ],
    'Someone joins your conversation. Include them without losing your original partner.',
  ),
  ConversationScenario(
    'cafe',
    'At the café',
    'You and a friend are choosing a place to sit and something to order.',
    'Compare preferences and agree on a plan.',
    [
      'What would you like to order, and why?',
      'Your friend prefers somewhere quieter. What could you suggest?',
      'How will you confirm both orders before paying?',
    ],
    'The café is closing early. Negotiate a new plan.',
  ),
  ConversationScenario(
    'family',
    'Family stories',
    'A new friend wants to understand the people who matter to you.',
    'Describe relationships with clear references.',
    [
      'Who would you introduce first?',
      'What is one thing that makes that person memorable?',
      'How will you distinguish two people with a similar description?',
    ],
    'Your partner confuses two relatives. Re-establish who is who.',
  ),
  ConversationScenario(
    'weekend',
    'The weekend plan',
    'Two friends have different schedules, budgets, and ideas.',
    'Negotiate an outing and confirm details.',
    [
      'What would you enjoy doing this weekend?',
      'What time and place could work for both of you?',
      'How would you explain a change to the plan?',
    ],
    'The weather changes. Propose an alternative and check agreement.',
  ),
  ConversationScenario(
    'travel',
    'A trip with a twist',
    'You are planning a short trip with someone whose priorities differ from yours.',
    'Compare options, sequence events, and repair misunderstanding.',
    [
      'Where would you go, and what matters most to you?',
      'How would you compare two travel options?',
      'Your partner misunderstood the departure date. How do you clarify?',
    ],
    'Your first choice is unavailable. Explain your backup plan.',
  ),
  ConversationScenario(
    'directions',
    'Finding your way',
    'A visitor needs directions through a building you know well.',
    'Establish space and give a coherent route.',
    [
      'Where is the starting point and the destination?',
      'Which landmark makes the first turn clear?',
      'How could you check that your partner understood the route?',
    ],
    'The usual entrance is closed. Describe a different route.',
  ),
  ConversationScenario(
    'home',
    'A place to call home',
    'You and a housemate are deciding how to arrange a shared space.',
    'Describe locations and negotiate preferences.',
    [
      'How would you describe the current layout?',
      'Which change would help the most, and why?',
      'Your partner imagines a different arrangement. How can you compare them?',
    ],
    'One piece of furniture will not fit. Solve the problem together.',
  ),
  ConversationScenario(
    'work',
    'Working together',
    'Your team needs to agree on responsibilities and a deadline.',
    'Explain a process and reach a shared understanding.',
    [
      'What is the goal, and what needs to happen first?',
      'How would you divide the work fairly?',
      'What would you say if a deadline seemed unrealistic?',
    ],
    'A teammate is absent. Reorganize the plan without blaming them.',
  ),
  ConversationScenario(
    'food',
    'Recipes and memories',
    'A friend asks about a dish that means something to you.',
    'Sequence a process and connect it to a personal story.',
    [
      'What dish would you choose, and what memory comes with it?',
      'What are the major steps to prepare it?',
      'How would you explain a substitution?',
    ],
    'Your friend has a different ingredient. Adapt the recipe together.',
  ),
  ConversationScenario(
    'hobbies',
    'Passions and hobbies',
    'Two people are comparing an activity each knows well.',
    'Explain unfamiliar ideas and ask useful follow-ups.',
    [
      'What activity could you talk about for hours?',
      'How would you explain it to someone who has never tried it?',
      'What might surprise a beginner?',
    ],
    'Your partner dislikes one part of the activity. Find common ground.',
  ),
  ConversationScenario(
    'event',
    'A community event',
    'A planning group is organizing an inclusive gathering.',
    'Balance perspectives and describe an accessible plan.',
    [
      'Who is the event for, and what would make it welcoming?',
      'How would you make sightlines and visual announcements clear?',
      'How would you respond to a suggestion that changes the plan?',
    ],
    'Attendance doubles. Revisit space, responsibilities, and communication.',
  ),
  ConversationScenario(
    'school',
    'Learning something difficult',
    'A classmate feels stuck learning a new skill.',
    'Describe experience, offer support, and ask before advising.',
    [
      'What made this skill challenging for you?',
      'What strategy helped, and why?',
      'How could you ask what kind of support they want?',
    ],
    'Your first suggestion does not work for them. Adapt without assuming.',
  ),
  ConversationScenario(
    'narrative',
    'An unexpected encounter',
    'A friend wants to hear about a memorable event.',
    'Build a coherent narrative with clear participants and viewpoint.',
    [
      'Where does your story begin, and who is there?',
      'What changes the direction of the story?',
      'How would you retell it from another participant’s viewpoint?',
    ],
    'Your listener questions a detail. Clarify the sequence and return to the story.',
  ),
  ConversationScenario(
    'technology',
    'Technology and daily life',
    'Two people disagree about a tool they use every day.',
    'Explain an opinion with examples and consider trade-offs.',
    [
      'What technology would you change, and why?',
      'What concrete example supports your opinion?',
      'What would someone with a different view say?',
    ],
    'A new constraint makes your favorite solution impractical. Revise your argument.',
  ),
  ConversationScenario(
    'environment',
    'A greener neighborhood',
    'Neighbors are discussing how to improve a shared space.',
    'Compare priorities, support a proposal, and consider consequences.',
    [
      'What improvement would make the biggest difference?',
      'How would you explain the costs and benefits?',
      'What concerns might a neighbor raise?',
    ],
    'The budget is cut in half. Build a compromise.',
  ),
  ConversationScenario(
    'media',
    'Stories in the media',
    'You and a friend interpret the same story differently.',
    'Summarize, distinguish inference, and support an interpretation.',
    [
      'What happened, in your own words?',
      'Which details support your interpretation?',
      'What remains uncertain or could be read differently?',
    ],
    'Your friend points out a missing perspective. Reconsider your summary.',
  ),
  ConversationScenario(
    'hypothesis',
    'What if…',
    'A discussion group is imagining a different future.',
    'Develop a hypothesis, explain consequences, and respond to a counterexample.',
    [
      'What change would you like to explore?',
      'What could happen next, and why?',
      'What assumption does your prediction depend on?',
    ],
    'An unexpected exception appears. Refine the hypothesis.',
  ),
  ConversationScenario(
    'values',
    'A meaningful disagreement',
    'Two friends disagree about a community decision while wanting to preserve trust.',
    'Represent another viewpoint fairly and build a nuanced response.',
    [
      'What do you think the other person values?',
      'How would you explain your own position with a concrete example?',
      'Where could both perspectives lead to a shared next step?',
    ],
    'Your partner feels misrepresented. Repair the interaction before continuing.',
  ),
];

ConversationTurn guidedTurn({
  required String topic,
  required String message,
  required int turnIndex,
}) {
  final scenario = conversationScenarios
      .where((s) => s.title == topic)
      .firstOrNull;
  final input = message.toLowerCase();
  final repair =
      input.contains('understand') ||
      input.contains('repeat') ||
      input.contains('clarif') ||
      input.contains('confus');
  final questions =
      scenario?.questions ??
      [
        'What would you like to explore about $topic?',
        'How would you explain your idea with a concrete example?',
        'What question would help you understand another perspective?',
      ];
  final question = turnIndex >= questions.length
      ? (scenario?.twist ??
            'A partner sees $topic differently. How would you explain your view and invite theirs?')
      : questions[turnIndex];
  return ConversationTurn(
    reply: repair
        ? 'Make room for repair: establish what you understood, then ask about the part that was unclear. Rehearse a clarification strategy you already know.'
        : 'This is your next guided conversation cue. Plan the meaning, then express it using ASL you have learned from a fluent signer.',
    suggestedReply: repair
        ? 'I understood part of that. Could we go over the last detail again?'
        : 'One example I could share is…',
    practiceGoal:
        scenario?.goal ??
        'Discuss $topic with a concrete example, a follow-up question, and room for clarification.',
    followUpQuestion: question,
  );
}
