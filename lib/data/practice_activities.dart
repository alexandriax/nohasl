/// Contextual rehearsal and conceptual checks, pending Deaf educator review.
/// Camera tasks use previously learned signs or a trusted signer reference.
/// Concept-choice correctness never assesses the learner's signed production.
class PracticeActivity {
  const PracticeActivity({
    required this.id,
    required this.title,
    required this.kind,
    required this.minimumLevel,
    required this.objectives,
    required this.instructions,
    required this.prompt,
    this.options = const [],
    this.correctOption,
    this.explanation = '',
    required this.cameraTask,
    required this.rubric,
    required this.conceptIds,
  });

  final String id;
  final String title;
  final String kind;
  final int minimumLevel;
  final List<String> objectives;
  final List<String> instructions;
  final String prompt;
  final List<String> options;
  final int? correctOption;
  final String explanation;
  final String cameraTask;
  final List<String> rubric;
  final List<String> conceptIds;
}

const List<PracticeActivity> practiceActivities = [
  PracticeActivity(
    id: 'attention-and-reply',
    title: 'A conversation has two sides',
    kind: 'information_gap',
    minimumLevel: 1,
    objectives: ['Establish visual attention.', 'Leave room for a reply.'],
    instructions: [
      'Picture a friend looking away from you.',
      'Plan a greeting, a pause, and a response.',
      'Rehearse each role separately, using signs you already know.',
    ],
    prompt:
        'Your friend is looking at a map. What comes before your signed question?',
    options: [
      'Get their visual attention.',
      'Sign your question faster.',
      'Keep signing while they look away.',
    ],
    correctOption: 0,
    explanation:
        'Visual access comes first. The receiver needs to be looking before they can follow the question.',
    cameraTask:
        'Rehearse getting attention, greeting, pausing, and responding. Keep both face and hands visible.',
    rubric: [
      'I established visual attention.',
      'I paused for the other person.',
      'I could see my face and hands.',
    ],
    conceptIds: ['visual-attention', 'turn-taking'],
  ),
  PracticeActivity(
    id: 'name-exchange',
    title: 'Meet Maya and Leo',
    kind: 'fingerspelling',
    minimumLevel: 1,
    objectives: [
      'Rehearse a meaningful name exchange.',
      'Recognize when to request repetition.',
    ],
    instructions: [
      'Use a trusted alphabet reference for letters you have learned.',
      'Rehearse introducing Maya, then Leo, with an unhurried pause.',
      'Hide the names and try to recall the exchange.',
    ],
    prompt:
        'You missed the middle of a fingerspelled name. What helps the exchange?',
    options: [
      'Pretend you understood.',
      'Request repetition or clarification.',
      'Guess without checking.',
    ],
    correctOption: 1,
    explanation:
        'A clarification request helps both people establish the intended name. It is a useful conversational skill.',
    cameraTask:
        'Fingerspell MAYA and LEO only if you have learned those letters. Otherwise rehearse the introduction and plan a clarification request.',
    rubric: [
      'I checked unfamiliar letters against a reference.',
      'I left a clear pause between names.',
      'I could ask for repetition.',
    ],
    conceptIds: ['fingerspelling-names', 'repair'],
  ),
  PracticeActivity(
    id: 'signing-space-check',
    title: 'Find your comfortable frame',
    kind: 'self_review',
    minimumLevel: 1,
    objectives: [
      'Make the signing space visible.',
      'Notice framing without judging language ability.',
    ],
    instructions: [
      'Position the camera at a comfortable distance.',
      'Rehearse a familiar short exchange.',
      'Check the edges of the frame and adjust your position.',
    ],
    prompt: 'Your hands leave the frame. What does this tell you?',
    options: [
      'Your ASL is wrong.',
      'You should never move your arms.',
      'Your camera framing needs adjustment.',
    ],
    correctOption: 2,
    explanation:
        'Camera visibility is a capture issue, not a measure of ASL skill.',
    cameraTask:
        'Try two familiar signs and a pause. Adjust the frame so your face, shoulders, and full movements remain visible.',
    rubric: [
      'My face stayed visible.',
      'My movements stayed in frame.',
      'My posture felt comfortable.',
    ],
    conceptIds: ['signing-space', 'camera-framing'],
  ),
  PracticeActivity(
    id: 'greeting-memory',
    title: 'A hello without hints',
    kind: 'memory',
    minimumLevel: 1,
    objectives: [
      'Retrieve a familiar exchange before reviewing.',
      'Describe uncertainty honestly.',
    ],
    instructions: [
      'Choose a greeting you have already learned from a signer.',
      'Close the reference and rehearse from memory.',
      'Reopen it and note one thing to revisit.',
    ],
    prompt:
        'Try first, then compare. Which part of your greeting was easiest to recall?',
    cameraTask:
        'Rehearse a brief greeting from memory. Use a camera or a mirror; the reflection is your own assessment.',
    rubric: [
      'I tried before opening the reference.',
      'I compared with a trusted model.',
      'I named one next step.',
    ],
    conceptIds: ['greetings', 'retrieval-practice'],
  ),
  PracticeActivity(
    id: 'number-message',
    title: 'The table for four',
    kind: 'number_message',
    minimumLevel: 2,
    objectives: [
      'Keep quantity and time distinct.',
      'Confirm a practical message.',
    ],
    instructions: [
      'Read the message: a table for four people at six.',
      'Plan how to distinguish the number of people from the time.',
      'Rehearse with number forms you have learned from a signer.',
    ],
    prompt: 'In this message, what does four describe?',
    options: [
      'The arrival time.',
      'The number of people.',
      'The table location.',
    ],
    correctOption: 1,
    explanation:
        'Four is the party size; six is the time. This checks message meaning, not production of ASL number forms.',
    cameraTask:
        'Rehearse conveying the party size and time, then take the receiver role and confirm both details.',
    rubric: [
      'I kept quantity and time distinct.',
      'I checked unfamiliar number forms.',
      'I confirmed the important details.',
    ],
    conceptIds: ['numbers-in-context', 'confirmation'],
  ),
  PracticeActivity(
    id: 'calendar-change',
    title: 'One plan, one change',
    kind: 'information_gap',
    minimumLevel: 2,
    objectives: [
      'Communicate a changed plan.',
      'Confirm the revised information.',
    ],
    instructions: [
      'Role A: you planned to meet on Tuesday.',
      'Role B: you are available Thursday instead.',
      'Rehearse proposing the change and confirming the final day.',
    ],
    prompt: 'After agreeing to Thursday, what should both people understand?',
    options: [
      'Tuesday remains the only plan.',
      'The day does not matter.',
      'Thursday is the revised meeting day.',
    ],
    correctOption: 2,
    explanation:
        'A successful repair establishes the same revised plan for both participants.',
    cameraTask:
        'Use familiar signs to propose and confirm the changed day. Pause when changing roles.',
    rubric: [
      'I identified the original plan.',
      'I made the change clear.',
      'Both roles confirmed the same result.',
    ],
    conceptIds: ['time-and-plans', 'conversation-repair'],
  ),
  PracticeActivity(
    id: 'preference-pair',
    title: 'A picnic everyone enjoys',
    kind: 'information_gap',
    minimumLevel: 2,
    objectives: [
      'Exchange preferences.',
      'Use shared information to make a plan.',
    ],
    instructions: [
      'Role A enjoys apples and water.',
      'Role B enjoys bread and apples.',
      'Identify something both people would enjoy, then rehearse the exchange.',
    ],
    prompt: 'Which item appears in both people’s preferences?',
    options: ['Apples.', 'Water.', 'Bread.'],
    correctOption: 0,
    explanation:
        'Apples are the shared preference. The signed rehearsal adds a chance to ask and respond.',
    cameraTask:
        'Ask about preferences, switch roles to respond, then propose the shared choice using signs you know.',
    rubric: [
      'I distinguished the two people.',
      'I asked and responded.',
      'I connected the response to the final choice.',
    ],
    conceptIds: ['preferences', 'questions-and-responses'],
  ),
  PracticeActivity(
    id: 'name-repair',
    title: 'Was that Nina or Mina?',
    kind: 'fingerspelling',
    minimumLevel: 2,
    objectives: [
      'Resolve uncertainty in a name.',
      'Confirm meaning rather than guess.',
    ],
    instructions: [
      'Use a trusted reference to review the relevant letters.',
      'Imagine you caught most of a name, but missed its first letter.',
      'Rehearse a clarification and a confirmation.',
    ],
    prompt: 'What detail distinguishes these two written names?',
    options: ['The final letter.', 'The first letter.', 'Their length.'],
    correctOption: 1,
    explanation:
        'The first letter distinguishes NINA from MINA. A real receptive test requires a signer video, not these written labels.',
    cameraTask:
        'Rehearse the two names using learned letter forms; include an explicit request to clarify the first letter.',
    rubric: [
      'I isolated the uncertain detail.',
      'I checked the reference.',
      'I confirmed the name after clarification.',
    ],
    conceptIds: ['fingerspelling-names', 'targeted-repair'],
  ),
  PracticeActivity(
    id: 'desk-map',
    title: 'Rebuild my desk',
    kind: 'spatial_scene',
    minimumLevel: 3,
    objectives: [
      'Maintain a stable spatial arrangement.',
      'Check a receiver’s interpretation.',
    ],
    instructions: [
      'Imagine a notebook in the center, a cup to its left, and a lamp behind it.',
      'Plan a description from one consistent viewpoint.',
      'Switch roles and reconstruct the scene.',
    ],
    prompt: 'In the written scene, where is the cup relative to the notebook?',
    options: ['Behind it.', 'To its right.', 'To its left.'],
    correctOption: 2,
    explanation:
        'The written layout puts the cup to the left. The camera task practices describing a spatial relationship, not a prescribed sign order.',
    cameraTask:
        'Establish the objects and rehearse their relationships using constructions you have learned. Keep the same viewpoint.',
    rubric: [
      'I introduced each object.',
      'I kept the viewpoint stable.',
      'I checked whether the receiver could rebuild the scene.',
    ],
    conceptIds: ['spatial-reference', 'viewpoint'],
  ),
  PracticeActivity(
    id: 'park-route',
    title: 'Meet at the fountain',
    kind: 'spatial_scene',
    minimumLevel: 3,
    objectives: [
      'Sequence a route.',
      'Use landmarks to support understanding.',
    ],
    instructions: [
      'Picture an entrance, then a bridge, then a fountain.',
      'Plan a route that names those landmarks in order.',
      'Ask the imagined receiver to repeat the route.',
    ],
    prompt: 'What comes immediately before the fountain in this route?',
    options: ['The bridge.', 'The entrance.', 'A landmark not mentioned.'],
    correctOption: 0,
    explanation:
        'The sequence is entrance, bridge, fountain. Clear landmarks help a receiver follow the route.',
    cameraTask:
        'Rehearse the route with familiar spatial constructions. Switch roles and check the sequence from memory.',
    rubric: [
      'I established the starting point.',
      'I kept the sequence clear.',
      'I checked the receiver’s understanding.',
    ],
    conceptIds: ['directions', 'sequencing'],
  ),
  PracticeActivity(
    id: 'two-people-map',
    title: 'Keep Alex and Sam distinct',
    kind: 'spatial_scene',
    minimumLevel: 3,
    objectives: [
      'Track two referents.',
      'Avoid ambiguity when switching between people.',
    ],
    instructions: [
      'Alex borrowed Sam’s notebook.',
      'Sam later asks Alex to return it.',
      'Plan how you will identify each person before referring back to them.',
    ],
    prompt: 'Who should return the notebook?',
    options: ['Sam.', 'Alex.', 'A third person.'],
    correctOption: 1,
    explanation:
        'Alex borrowed it from Sam. Establishing referents supports clear later references.',
    cameraTask:
        'Introduce both people and rehearse the exchange. Check that a viewer could tell who is acting at each point.',
    rubric: [
      'I introduced both people.',
      'My references remained consistent.',
      'The ownership and action were clear.',
    ],
    conceptIds: ['referent-tracking', 'spatial-reference'],
  ),
  PracticeActivity(
    id: 'message-detail',
    title: 'Room 12, not 20',
    kind: 'number_message',
    minimumLevel: 3,
    objectives: [
      'Notice a critical numerical detail.',
      'Repair a misunderstanding precisely.',
    ],
    instructions: [
      'The correct meeting room is 12.',
      'Your imagined partner confirms room 20.',
      'Plan a short correction and a second confirmation.',
    ],
    prompt: 'What information needs repair?',
    options: [
      'The meeting topic.',
      'The number of people.',
      'The room number.',
    ],
    correctOption: 2,
    explanation:
        'The mismatch is the room number. A focused clarification avoids unnecessarily restarting the whole exchange.',
    cameraTask:
        'Use learned number forms to correct and confirm the room. Review the forms with a trusted reference if uncertain.',
    rubric: [
      'I isolated the changed detail.',
      'I checked number production against a reference.',
      'I confirmed the corrected room.',
    ],
    conceptIds: ['numbers-in-context', 'targeted-repair'],
  ),
  PracticeActivity(
    id: 'lost-and-found',
    title: 'The missing blue bag',
    kind: 'narrative_retell',
    minimumLevel: 4,
    objectives: [
      'Retell a connected sequence.',
      'Distinguish setup, problem, and resolution.',
    ],
    instructions: [
      'A traveler leaves a blue bag at a café.',
      'A server notices it and brings it to the front desk.',
      'The traveler returns and finds it there. Hide the text and retell the events.',
    ],
    prompt: 'What resolves the traveler’s problem?',
    options: [
      'Finding the bag at the front desk.',
      'Leaving the café again.',
      'Changing the bag’s color.',
    ],
    correctOption: 0,
    explanation:
        'The bag is recovered at the front desk. This checks narrative meaning; the signed retell is self-reviewed.',
    cameraTask:
        'Retell the story with stable references for the traveler, server, and bag. Then note any unclear transition.',
    rubric: [
      'I established the people and object.',
      'I kept the event order clear.',
      'The resolution connected to the original problem.',
    ],
    conceptIds: ['narrative-sequence', 'referent-tracking'],
  ),
  PracticeActivity(
    id: 'perspective-switch',
    title: 'The same surprise, two views',
    kind: 'role_shift',
    minimumLevel: 4,
    objectives: [
      'Distinguish a narrator from characters.',
      'Keep perspective changes understandable.',
    ],
    instructions: [
      'One friend plans a surprise picnic.',
      'The other thinks everyone has forgotten their birthday.',
      'Plan the story from each person’s perspective.',
    ],
    prompt: 'Why do the friends understand the situation differently?',
    options: [
      'They have identical information.',
      'Only one knows about the surprise.',
      'Neither friend knows it is a birthday.',
    ],
    correctOption: 1,
    explanation:
        'Their knowledge differs. A retelling should help the viewer track whose perspective is being shown.',
    cameraTask:
        'Rehearse a brief version from each perspective using role-shift techniques you have learned from a signer.',
    rubric: [
      'I established who knew what.',
      'My perspective changes were clear.',
      'I returned to the narrator consistently.',
    ],
    conceptIds: ['role-shift', 'perspective'],
  ),
  PracticeActivity(
    id: 'face-and-intention',
    title: 'Concern, surprise, reassurance',
    kind: 'nonmanual_reflection',
    minimumLevel: 4,
    objectives: [
      'Reflect on expressive intent.',
      'Distinguish affect from grammatical nonmanual features.',
    ],
    instructions: [
      'Choose a familiar, reviewed exchange.',
      'Imagine delivering it with concern, then reassurance.',
      'Consult the reference for any grammatical facial features rather than substituting an emotion.',
    ],
    prompt:
        'Does an emotional expression replace the grammatical features of a signed sentence?',
    options: [
      'Yes, any emotion is a complete substitute.',
      'Only if the movement is exaggerated.',
      'No; review the grammatical features separately.',
    ],
    correctOption: 2,
    explanation:
        'Affect and grammatical nonmanual features are distinct instructional considerations. A signer reference is needed to evaluate their realization.',
    cameraTask:
        'Rehearse a familiar exchange while observing face and upper body. Reflect on intention and consult a teacher about uncertain grammatical features.',
    rubric: [
      'I kept my face visible.',
      'I distinguished intended emotion from grammar.',
      'I noted uncertainty instead of assuming correctness.',
    ],
    conceptIds: ['nonmanual-features', 'affect-and-intention'],
  ),
  PracticeActivity(
    id: 'retell-after-delay',
    title: 'The story that stayed with you',
    kind: 'memory',
    minimumLevel: 4,
    objectives: [
      'Retrieve meaning after a pause.',
      'Notice omissions without memorizing English wording.',
    ],
    instructions: [
      'Choose a short story you have studied with a signer reference.',
      'Pause and do another activity before returning.',
      'Retell its meaning without the reference, then compare.',
    ],
    prompt: 'What meaning did you retain, and what would you review next?',
    cameraTask:
        'Retell the main events. Compare against the reference and describe one retained detail and one omission.',
    rubric: [
      'I attempted delayed recall.',
      'I preserved the central meaning.',
      'I identified an omission or uncertainty.',
    ],
    conceptIds: ['delayed-retrieval', 'narrative-retell'],
  ),
  PracticeActivity(
    id: 'event-access',
    title: 'Plan an accessible gathering',
    kind: 'information_gap',
    minimumLevel: 5,
    objectives: ['Gather missing information.', 'Negotiate a shared plan.'],
    instructions: [
      'Role A knows the venue has movable chairs and bright windows.',
      'Role B knows six people want a clear view of one another.',
      'Exchange information and plan the seating; avoid assuming one arrangement fits everyone.',
    ],
    prompt: 'Which missing information is useful to ask the group?',
    options: [
      'Their individual visual-access and seating preferences.',
      'Which person should be excluded.',
      'Whether conversation can happen without anyone seeing.',
    ],
    correctOption: 0,
    explanation:
        'Ask participants what supports their access. Planning should respond to the people attending.',
    cameraTask:
        'Rehearse asking about access preferences, explaining the room, and confirming a seating plan.',
    rubric: [
      'I asked rather than assumed access needs.',
      'I conveyed relevant room details.',
      'I confirmed the agreed plan.',
    ],
    conceptIds: ['collaborative-planning', 'access-and-community'],
  ),
  PracticeActivity(
    id: 'opinion-and-reason',
    title: 'Make a case for the park',
    kind: 'discussion',
    minimumLevel: 5,
    objectives: [
      'Connect an opinion to supporting reasons.',
      'Respond to an alternative.',
    ],
    instructions: [
      'You prefer meeting outdoors because the park has open space.',
      'Your partner is concerned about rain.',
      'Prepare your reason, acknowledge their concern, and suggest a backup.',
    ],
    prompt: 'Which response addresses the partner’s concern?',
    options: [
      'Repeat the preference without explanation.',
      'Offer an indoor backup if it rains.',
      'Ignore the weather entirely.',
    ],
    correctOption: 1,
    explanation:
        'A backup responds to the stated concern while preserving a practical shared plan.',
    cameraTask:
        'Rehearse the preference, supporting reason, acknowledgment, and backup in your own signed expression.',
    rubric: [
      'I connected opinion and reason.',
      'I acknowledged the other view.',
      'My response addressed the concern.',
    ],
    conceptIds: ['opinion-and-reason', 'discussion-repair'],
  ),
  PracticeActivity(
    id: 'variation-not-error',
    title: 'A familiar idea, a different signer',
    kind: 'receptive_strategy',
    minimumLevel: 5,
    objectives: [
      'Approach unfamiliar variation with curiosity.',
      'Use context and clarification.',
    ],
    instructions: [
      'Find two trusted signer references for a familiar topic.',
      'Note a difference without deciding it is an error.',
      'Ask a qualified teacher about region, context, or usage if needed.',
    ],
    prompt:
        'An unfamiliar signer uses a form you do not recognize. What is a useful first response?',
    options: [
      'Assume only your first teacher’s form is valid.',
      'Treat all context as irrelevant.',
      'Use context and ask for clarification.',
    ],
    correctOption: 2,
    explanation:
        'Variation and context matter. An unfamiliar form should prompt inquiry rather than an automatic error judgment.',
    cameraTask:
        'Rehearse a respectful clarification request. Reflect on how you would verify an unfamiliar form.',
    rubric: [
      'I avoided equating unfamiliarity with error.',
      'I sought context.',
      'I identified a trusted route to clarification.',
    ],
    conceptIds: ['language-variation', 'clarification'],
  ),
  PracticeActivity(
    id: 'group-summary',
    title: 'Bring the group up to speed',
    kind: 'narrative_retell',
    minimumLevel: 5,
    objectives: [
      'Summarize without losing key decisions.',
      'Distinguish decisions from open questions.',
    ],
    instructions: [
      'The group chose Saturday and the library.',
      'Transport is still undecided.',
      'Prepare a concise update for someone who missed the discussion.',
    ],
    prompt: 'Which detail remains unresolved?',
    options: ['Transport.', 'The day.', 'The meeting place.'],
    correctOption: 0,
    explanation:
        'Saturday and the library are agreed; transport still needs a decision.',
    cameraTask:
        'Rehearse an update that clearly separates agreed decisions from the remaining question.',
    rubric: [
      'I preserved the agreed details.',
      'I identified the open question.',
      'I checked what the new participant understood.',
    ],
    conceptIds: ['summarizing', 'discourse-organization'],
  ),
  PracticeActivity(
    id: 'ambiguous-message',
    title: 'Untangle the message',
    kind: 'information_gap',
    minimumLevel: 6,
    objectives: [
      'Locate ambiguity in connected discourse.',
      'Ask a precise follow-up.',
    ],
    instructions: [
      'Jordan told Casey that their presentation had moved.',
      'The message does not identify whose presentation or the new time.',
      'List the missing information before rehearsing a clarification.',
    ],
    prompt: 'What is the most useful follow-up?',
    options: [
      'Assume the missing details.',
      'Ask whose presentation and its revised time.',
      'Change to an unrelated topic.',
    ],
    correctOption: 1,
    explanation:
        'The follow-up targets the unresolved referent and scheduling detail.',
    cameraTask:
        'Rehearse the ambiguous exchange and a precise repair, then summarize the clarified result.',
    rubric: [
      'I noticed both sources of ambiguity.',
      'My follow-up was specific.',
      'I confirmed a shared interpretation.',
    ],
    conceptIds: ['ambiguity-repair', 'referent-tracking'],
  ),
  PracticeActivity(
    id: 'unexpected-question',
    title: 'The follow-up you did not prepare',
    kind: 'conversation',
    minimumLevel: 6,
    objectives: [
      'Adapt a prepared explanation.',
      'Maintain a conversation through clarification.',
    ],
    instructions: [
      'Prepare a short account of a recent experience.',
      'Ask a practice partner to choose an unexpected follow-up, or select a new detail yourself.',
      'Respond without restarting the entire account.',
    ],
    prompt:
        'Which part of your explanation would change for someone unfamiliar with the situation?',
    cameraTask:
        'Rehearse a response to a follow-up question. If working alone, distinguish planning a response from actual spontaneous partner interaction.',
    rubric: [
      'I responded to the actual question.',
      'I supplied useful missing context.',
      'I used clarification when needed.',
    ],
    conceptIds: ['spontaneous-response', 'audience-adaptation'],
  ),
  PracticeActivity(
    id: 'two-audiences',
    title: 'One explanation, two audiences',
    kind: 'discussion',
    minimumLevel: 6,
    objectives: [
      'Adapt context and detail to an audience.',
      'Preserve the central meaning.',
    ],
    instructions: [
      'Choose a topic you know well.',
      'Explain it first to a friend familiar with the topic, then to a newcomer.',
      'Compare what context and detail each version needs.',
    ],
    prompt: 'What should remain consistent when adapting an explanation?',
    options: [
      'Every pause and movement must be identical.',
      'The newcomer should receive no context.',
      'The central meaning should remain intact.',
    ],
    correctOption: 2,
    explanation:
        'Audience adaptation changes supporting detail while preserving the intended message.',
    cameraTask:
        'Rehearse the two versions using your own established signing skills. Ask a fluent reviewer whether each explanation is clear.',
    rubric: [
      'I preserved the central meaning.',
      'I adjusted relevant background detail.',
      'I sought feedback beyond my own impression.',
    ],
    conceptIds: ['audience-adaptation', 'extended-explanation'],
  ),
  PracticeActivity(
    id: 'portfolio-return',
    title: 'Return to an earlier story',
    kind: 'portfolio',
    minimumLevel: 6,
    objectives: [
      'Compare self-review across time.',
      'Choose a concrete next learning goal.',
    ],
    instructions: [
      'Choose an earlier story or explanation and read your saved reflection.',
      'Rehearse it again with a fresh perspective.',
      'Record what changed and what still needs feedback; request educator input when possible.',
    ],
    prompt: 'What can your comparison establish on its own?',
    options: [
      'Your observations about your practice.',
      'An official proficiency rating.',
      'Professional interpreting qualification.',
    ],
    correctOption: 0,
    explanation:
        'A self-review documents your observations. Independent proficiency assessment and professional qualifications require separate processes.',
    cameraTask:
        'Rehearse the earlier task and save a specific reflection. No camera recording is saved by this portfolio.',
    rubric: [
      'I compared with an earlier reflection.',
      'I described an observable change.',
      'I chose a next step without claiming certification.',
    ],
    conceptIds: ['reflective-practice', 'learning-goals'],
  ),
];
