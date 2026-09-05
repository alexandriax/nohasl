/// Authored demonstration curriculum. All instructional content and sign media
/// require Deaf educator review before an instructional production release.
/// XP and completion represent participation, never ASL proficiency.
enum LessonMode { guided, camera, story, conversation, recall }

class CourseLevel {
  const CourseLevel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.units,
  });

  final String id;
  final String title;
  final String subtitle;
  final String description;
  final List<CourseUnit> units;
}

class CourseUnit {
  const CourseUnit({
    required this.id,
    required this.title,
    required this.description,
    required this.lessons,
  });

  final String id;
  final String title;
  final String description;
  final List<Lesson> lessons;
}

class Lesson {
  const Lesson({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.minutes,
    required this.xp,
    required this.mode,
    required this.steps,
  });

  final String id;
  final String title;
  final String subtitle;
  final int minutes;
  final int xp;
  final LessonMode mode;
  final List<LessonStep> steps;
}

class LessonStep {
  const LessonStep({
    required this.title,
    required this.body,
    required this.prompt,
    this.choices = const [],
    this.correctChoice,
    this.signWord,
  });

  final String title;
  final String body;
  final String prompt;
  final List<String> choices;
  final int? correctChoice;
  final String? signWord;
}

/// Product levels are learning stages, not official proficiency ratings.
const List<CourseLevel> courseLevels = [
  CourseLevel(
    id: "first-connections",
    title: "First connections",
    subtitle: "Absolute beginner",
    description:
        "Start seeing language differently. Build a comfortable signing space, meet someone new, and discover why your face matters as much as your hands.",
    units: [
      CourseUnit(
        id: "hello-world",
        title: "Hello, world",
        description:
            "Your first signs, your signing space, and a little everyday kindness.",
        lessons: [
          Lesson(
            id: "a-first-hello",
            title: "A first hello",
            subtitle: "One small wave. A whole new connection.",
            mode: LessonMode.guided,
            minutes: 4,
            xp: 20,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "ASL is a complete visual language. A natural side-to-side wave can greet someone. First make sure they can see you, then give a relaxed greeting and allow time for a reply.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt: "What helps a visual conversation begin?",
                choices: [
                  "Making every movement as large as possible",
                  "Getting the other person’s visual attention",
                  "Signing before they look up",
                ],
                correctChoice: 1,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Frame your face, shoulders, and hands. Try a relaxed side-to-side greeting wave, then pause as if a friend is replying. This is a self-review exercise; the camera does not judge your sign.",
                prompt:
                    "Try your hello. Can you see your face and the whole movement?",
                signWord: "HELLO",
              ),
            ],
          ),
          Lesson(
            id: "space-to-sign",
            title: "Space to sign",
            subtitle: "Find a frame that feels natural.",
            mode: LessonMode.camera,
            minutes: 5,
            xp: 25,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "A camera view needs room for the face, upper body, and both hands. Facial expression and body position can carry language. Comfortable lighting and a clear background make movement easier to see.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt:
                    "Your hands keep leaving the bottom of the preview. What should you try?",
                choices: [
                  "Rush through the movement",
                  "Adjust your distance or camera angle",
                  "Hide your face to fit only your hands",
                ],
                correctChoice: 1,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Sit or stand comfortably. Move both hands through a comfortable space in front of your body, without stretching. Adjust your framing until your face and hands remain visible.",
                prompt:
                    "Check the top, sides, and bottom of your signing space.",
              ),
            ],
          ),
          Lesson(
            id: "a-little-kindness",
            title: "A little kindness",
            subtitle: "Notice gratitude, context, and connection.",
            mode: LessonMode.recall,
            minutes: 5,
            xp: 25,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "A conversation is more than a vocabulary list. Gratitude, greetings, and acknowledgment fit different moments. Learn each expression from a fluent signer in context; an English label alone cannot show the complete movement.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt:
                    "Someone has patiently repeated their name. What fits the moment?",
                choices: [
                  "Start a different topic immediately",
                  "Acknowledge them and express thanks",
                  "Pretend you understood before you did",
                ],
                correctChoice: 1,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Think of a small favor someone did for you. Rehearse the greeting you have learned, then pause. If you already know THANK YOU from a fluent teacher, add it; otherwise make that your next reference-sign goal.",
                prompt: "What would you like to thank someone for?",
              ),
            ],
          ),
        ],
      ),
      CourseUnit(
        id: "your-first-connections",
        title: "Your first connections",
        description: "Names, introductions, and the confidence to ask again.",
        lessons: [
          Lesson(
            id: "names-have-rhythm",
            title: "Names have rhythm",
            subtitle: "Meet fingerspelling without the rush.",
            mode: LessonMode.guided,
            minutes: 6,
            xp: 30,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "Fingerspelling is part of ASL, often used for names. Build legible letter shapes and smooth transitions before speed. Watch the word as a whole as your receptive skills grow; a spelling chart alone does not teach movement.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt:
                    "What is a useful first goal when fingerspelling your name?",
                choices: [
                  "Moving the hand to a new spot for every letter",
                  "Clear, comfortable letter transitions",
                  "The fastest possible speed",
                ],
                correctChoice: 1,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Write your name and mark which letters you know from a verified signing model. Rehearse only those letters slowly. Note any letter that needs an educator demonstration instead of guessing its shape.",
                prompt:
                    "Which transition in your name would you like to make smoother?",
              ),
            ],
          ),
          Lesson(
            id: "meet-someone-new",
            title: "Meet someone new",
            subtitle: "Turn a greeting into an exchange.",
            mode: LessonMode.conversation,
            minutes: 6,
            xp: 30,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "A first introduction has space for both people: greet, share a name, receive their name, and acknowledge. You can say that you are learning and ask for a slower pace. A two-way exchange matters more than a memorized speech.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt:
                    "Your partner begins sharing their name. What helps you follow?",
                choices: [
                  "Look away to plan your reply",
                  "Watch, allow them to finish, and clarify if needed",
                  "Start your next sentence immediately",
                ],
                correctChoice: 1,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Imagine meeting a neighbor at a community event. Rehearse a greeting, then leave a real pause for their turn. Add your name only with letter forms you have learned from a fluent signer.",
                prompt:
                    "Try the exchange once as yourself and once as your neighbor.",
              ),
            ],
          ),
          Lesson(
            id: "asking-again",
            title: "The power of again",
            subtitle: "Repair is part of conversation.",
            mode: LessonMode.camera,
            minutes: 5,
            xp: 25,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "Missing something is normal. Good communication includes asking for repetition, a slower pace, or clarification. An honest repair keeps both people connected; nodding without understanding can hide a misunderstanding.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt:
                    "You recognize only the first part of a name. What is the best next move?",
                choices: [
                  "Assume your partner must change topics",
                  "Ask for that part to be repeated",
                  "Guess and act certain",
                ],
                correctChoice: 1,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Rehearse a visible pause and attentive expression. If you know a request for repetition from class, practice it. Otherwise identify the request you need and bring it to your teacher or a verified lesson.",
                prompt:
                    "Imagine the missed name. Practice stopping kindly instead of guessing.",
              ),
            ],
          ),
        ],
      ),
      CourseUnit(
        id: "a-visual-language",
        title: "A visual language",
        description:
            "Explore the ingredients of a sign and the people behind the language.",
        lessons: [
          Lesson(
            id: "five-things-to-notice",
            title: "Five things to notice",
            subtitle: "Look beyond the handshape.",
            mode: LessonMode.guided,
            minutes: 6,
            xp: 30,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "When studying a sign, notice handshape, palm orientation, location, movement, and nonmanual features such as the face and body. A change in one feature can change meaning. Observe the whole signer, not only the fingers.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt:
                    "Two signs use similar hands. What else could distinguish them?",
                choices: [
                  "Location, movement, orientation, and nonmanual features",
                  "Only the English word underneath",
                  "Nothing; matching hands mean matching signs",
                ],
                correctChoice: 0,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Return to your greeting. Describe its handshape, direction, location, movement, and expression in your own words. Use your preview to notice what is visible, without treating your observation as a correctness score.",
                prompt: "Which feature did you notice for the first time?",
                signWord: "HELLO",
              ),
            ],
          ),
          Lesson(
            id: "your-face-is-grammar",
            title: "Your face is grammar",
            subtitle: "Questions have a visual shape.",
            mode: LessonMode.camera,
            minutes: 6,
            xp: 30,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "In ASL, the face and body can mark grammatical information as well as emotion. Yes/no questions commonly include raised brows; information questions often use lowered brows. Their timing and context must be learned with complete signed examples.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt:
                    "Why should a learning video include the signer’s face?",
                choices: [
                  "Hands alone always carry the entire message",
                  "The face can carry grammar as well as emotion",
                  "It is only useful for recognizing the person",
                ],
                correctChoice: 1,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "With relaxed shoulders, compare a neutral face and gently raised brows in the preview. Notice whether the change is visible. This is awareness practice, not a complete ASL question or an instruction to exaggerate.",
                prompt:
                    "Keep your whole face in frame while you explore the difference.",
              ),
            ],
          ),
          Lesson(
            id: "language-and-community",
            title: "Language lives in community",
            subtitle: "Start with curiosity and respect.",
            mode: LessonMode.story,
            minutes: 7,
            xp: 35,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "Deaf communities are diverse. People choose their own identities and communication preferences. ASL is a language with culture and history; learning it includes listening to Deaf perspectives and joining appropriate learning spaces respectfully.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt:
                    "At an event, someone shares how they identify. How should you respond?",
                choices: [
                  "Correct them using a label you prefer",
                  "Assume every Deaf person communicates the same way",
                  "Use their chosen identity and communication preferences",
                ],
                correctChoice: 2,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Imagine arriving at a beginner-friendly Deaf-led event. Rehearse your greeting and plan one respectful question. Read the event’s expectations, compensate teachers, and do not assume attendees are there to provide lessons.",
                prompt:
                    "Choose one way you can be a thoughtful learner in a community space.",
              ),
            ],
          ),
        ],
      ),
    ],
  ),
  CourseLevel(
    id: "everyday-life",
    title: "Everyday life",
    subtitle: "Beginner",
    description:
        "Talk about the people, places, and rhythms that make up your day. Revisit familiar signs in small, useful conversations.",
    units: [
      CourseUnit(
        id: "people-and-places",
        title: "People and places",
        description: "Introduce your circle and make a space easy to picture.",
        lessons: [
          Lesson(
            id: "my-circle",
            title: "My circle",
            subtitle: "Introduce the people who matter.",
            mode: LessonMode.guided,
            minutes: 6,
            xp: 30,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "Introduce people clearly before referring back to them. Family and household descriptions should fit your actual life, including friends, chosen family, and different living arrangements. Learn vocabulary that lets you represent people respectfully.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt:
                    "What helps a partner understand who you are talking about?",
                choices: [
                  "Change the person without any signal",
                  "Assume every household has the same structure",
                  "Introduce the person before referring back to them",
                ],
                correctChoice: 2,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Choose two people important to you. Using signs you have learned, rehearse a brief introduction for each. Identify any relationship term you need to learn instead of substituting an unrelated sign.",
                prompt: "Can your introduction distinguish the two people?",
              ),
            ],
          ),
          Lesson(
            id: "where-things-belong",
            title: "Where things belong",
            subtitle: "Keep your references consistent.",
            mode: LessonMode.camera,
            minutes: 7,
            xp: 35,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "Signers can establish locations in signing space and refer back to them. A location becomes meaningful through context. Keep references consistent so your partner can follow which person or place you mean.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt:
                    "You establish the library on one side of your signing space. Later you should…",
                choices: [
                  "Refer back consistently unless you explain a change",
                  "Move it to another side without context",
                  "Avoid ever referring to it again",
                ],
                correctChoice: 0,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Imagine a library and a café. Plan distinct places for them in your signing space. Rehearse indicating each location in sequence using references already taught to you; this alone is not a full signed description.",
                prompt: "Does the café stay in the same place throughout?",
              ),
            ],
          ),
          Lesson(
            id: "find-the-blue-bag",
            title: "Find the blue bag",
            subtitle: "Describe enough to be understood.",
            mode: LessonMode.recall,
            minutes: 6,
            xp: 30,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "A useful description helps a partner identify the intended object. Color, size, location, and distinguishing details work together. Build descriptions from observed ASL examples rather than translating an English adjective list word by word.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt:
                    "Three bags are blue. Which detail is most useful next?",
                choices: [
                  "Changing to an unrelated subject",
                  "A distinguishing feature or location",
                  "Repeating only “blue” faster",
                ],
                correctChoice: 1,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Pick an object near you and decide which two details would distinguish it from similar objects. Rehearse the vocabulary you know, then check which description structure you need a teacher to model.",
                prompt:
                    "Could someone identify your object from those details?",
              ),
            ],
          ),
        ],
      ),
      CourseUnit(
        id: "everyday-rhythms",
        title: "Everyday rhythms",
        description: "Numbers, time, routines, and things you enjoy.",
        lessons: [
          Lesson(
            id: "numbers-in-context",
            title: "Numbers in context",
            subtitle: "A quantity is not a phone number.",
            mode: LessonMode.guided,
            minutes: 7,
            xp: 35,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "ASL number forms can vary with context, including quantities, ages, money, dates, and strings of digits. Learn numbers inside meaningful examples, and do not assume one isolated counting pattern works everywhere.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt:
                    "Why practice a phone number separately from counting objects?",
                choices: [
                  "All number contexts use identical rules",
                  "Number use and production depend on context",
                  "Phone numbers are never signed",
                ],
                correctChoice: 1,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Choose a small quantity and a fictional phone number. Label their different purposes. Rehearse only number forms you have learned in those contexts; keep real private contact information out of practice examples.",
                prompt: "Which number context do you encounter most often?",
              ),
            ],
          ),
          Lesson(
            id: "a-day-in-your-life",
            title: "A day in your life",
            subtitle: "Give your story a time frame.",
            mode: LessonMode.camera,
            minutes: 7,
            xp: 35,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "Time expressions help establish when events happen. Once a time frame is clear, connected information can build within it. Study complete examples to see where signers establish, maintain, and change that frame.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt:
                    "You switch from yesterday’s routine to tomorrow’s plan. What needs to be clear?",
                choices: [
                  "Nothing; the partner will always infer it",
                  "That the time frame has changed",
                  "Only that you are signing faster",
                ],
                correctChoice: 1,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Plan three familiar activities from your day. Rehearse them in order using learned vocabulary, with a clear beginning and ending. Note where a time expression would help a partner follow.",
                prompt:
                    "Can you keep the sequence clear without adding unnecessary details?",
              ),
            ],
          ),
          Lesson(
            id: "what-you-love",
            title: "What you love",
            subtitle: "Likes become invitations.",
            mode: LessonMode.conversation,
            minutes: 6,
            xp: 30,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "Preferences open a conversation: share an interest, ask about your partner, and follow up. A good response connects to what was just shared. Being interested matters as much as having interesting things to say.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt:
                    "Your partner says they enjoy hiking. Which follow-up keeps the exchange connected?",
                choices: [
                  "End the conversation because your hobbies differ",
                  "Ask about a place they like to hike",
                  "Ignore it and recite every hobby you know",
                ],
                correctChoice: 1,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Choose a hobby and imagine a partner who likes something different. Rehearse your known preference signs, a pause, and a relevant follow-up. Identify one new word that would make the exchange more personal.",
                prompt:
                    "What would you ask after learning your partner’s favorite activity?",
              ),
            ],
          ),
        ],
      ),
      CourseUnit(
        id: "neighborhood-cafe",
        title: "The neighborhood café",
        description:
            "A small story about ordering, meeting, and finding a seat.",
        lessons: [
          Lesson(
            id: "your-usual-order",
            title: "Your usual order",
            subtitle: "Turn vocabulary into a request.",
            mode: LessonMode.story,
            minutes: 7,
            xp: 35,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "You enter a café and the menu has changed. First establish what you want, then clarify the available options. In this text scenario, focus on the communication goal; English dialogue is not an ASL transcript.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt:
                    "The person taking your order offers two alternatives. What helps you choose?",
                choices: [
                  "Repeat the same request without acknowledging them",
                  "Clarify the options you did not understand",
                  "Choose randomly and pretend you understood",
                ],
                correctChoice: 1,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Pick a drink and one preference. Rehearse a request using vocabulary you already know. Pause for an imagined response, then practice a repair if the option you want is unavailable.",
                prompt:
                    "How would you keep the exchange moving if your first choice is unavailable?",
              ),
            ],
          ),
          Lesson(
            id: "a-seat-by-the-window",
            title: "A seat by the window",
            subtitle: "Make a location easy to find.",
            mode: LessonMode.camera,
            minutes: 7,
            xp: 35,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "Your friend is looking for your table. Choose a clear landmark and describe the table’s relationship to it. Spatial descriptions need a consistent perspective; signed models are essential for learning how to show that perspective.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt: "Which plan would best help your friend find you?",
                choices: [
                  "Change your perspective halfway through without explanation",
                  "Start with a visible landmark and a clear relative location",
                  "List unrelated furniture in no order",
                ],
                correctChoice: 1,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Imagine a window, a door, and two tables. Plan the layout in signing space. Rehearse a reference to your table using spatial forms you have learned, then check that your landmarks stay consistent.",
                prompt:
                    "Can you show the same table twice without moving your landmarks?",
              ),
            ],
          ),
          Lesson(
            id: "see-you-next-time",
            title: "See you next time",
            subtitle: "Finish a conversation with a connection.",
            mode: LessonMode.conversation,
            minutes: 8,
            xp: 40,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "At the café, you meet someone who is also learning. Exchange names, discuss a shared interest, and make a possible plan. Close the conversation clearly so both people know the exchange has ended.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt:
                    "Before you leave after suggesting a meeting, what should be clear?",
                choices: [
                  "Whether you agreed on a plan and understood its details",
                  "Only how much vocabulary you used",
                  "That every pause must be filled",
                ],
                correctChoice: 0,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Rehearse three beats: greeting, shared interest, and closing. Add one clarification about a fictional future plan. Use a comfortable pace and leave a turn for your imagined partner after each beat.",
                prompt:
                    "Which part felt connected, and which needs a model from your teacher?",
              ),
            ],
          ),
        ],
      ),
    ],
  ),
  CourseLevel(
    id: "connecting-ideas",
    title: "Connecting ideas",
    subtitle: "Developing",
    description:
        "Link thoughts, describe a world in space, and handle the small surprises of everyday conversation.",
    units: [
      CourseUnit(
        id: "making-plans",
        title: "Making plans",
        description: "Negotiate invitations, schedules, and changes.",
        lessons: [
          Lesson(
            id: "an-invitation",
            title: "An invitation",
            subtitle: "Offer a plan with room for a reply.",
            mode: LessonMode.conversation,
            minutes: 8,
            xp: 40,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "An invitation needs enough information to respond: an activity, a time, and relevant context. A yes/no question and an open information question have different purposes and nonmanual patterns.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt:
                    "You want to know which day works for your friend. What is the communication goal?",
                choices: [
                  "Ask for information about availability",
                  "Assume they accepted a specific date",
                  "Ask a question but leave no time to answer",
                ],
                correctChoice: 0,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Plan an invitation to a familiar activity. Identify where you need an information question and where a yes/no question fits. Rehearse forms you have learned with attention to the face and turn endings.",
                prompt:
                    "Can your partner tell what information you are asking for?",
              ),
            ],
          ),
          Lesson(
            id: "plans-can-change",
            title: "Plans can change",
            subtitle: "Explain, propose, and confirm.",
            mode: LessonMode.story,
            minutes: 8,
            xp: 40,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "Rain changes your park plan. Explain the relevant change, offer an alternative, and confirm the new agreement. Keep the old plan and new plan distinct so your partner knows what is happening now.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt: "What makes a changed plan easiest to follow?",
                choices: [
                  "Mention both plans without saying which is current",
                  "Only say that the old plan was bad",
                  "Explain the change and confirm the replacement plan",
                ],
                correctChoice: 2,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Imagine replacing a park visit with a café meeting. Rehearse the known vocabulary for the change and the alternative. End with a check that you and your partner mean the same time and place.",
                prompt: "Is your final plan unambiguous?",
              ),
            ],
          ),
          Lesson(
            id: "remember-the-details",
            title: "Remember the details",
            subtitle: "Retrieve, check, and repair.",
            mode: LessonMode.recall,
            minutes: 7,
            xp: 35,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "For this scenario, imagine a friend proposed meeting on Saturday afternoon at the library entrance. You remember the day and place but missed the exact time. Useful recall includes recognizing what you do not know.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt: "Which clarification is most focused?",
                choices: [
                  "Ask them to repeat their entire life story",
                  "Invent a time and treat it as agreed",
                  "Confirm the exact meeting time",
                ],
                correctChoice: 2,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Look away from the scenario and recall the day, location, and missing detail. Rehearse a clarification with learned signs. This is text-based planning practice, not a test of receptive ASL.",
                prompt:
                    "Which details are known, and which require a question?",
              ),
            ],
          ),
        ],
      ),
      CourseUnit(
        id: "describing-your-world",
        title: "Describing your world",
        description: "Build locations, movement, and clear comparisons.",
        lessons: [
          Lesson(
            id: "a-room-in-space",
            title: "A room in space",
            subtitle: "Build the scene before the details.",
            mode: LessonMode.guided,
            minutes: 8,
            xp: 40,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "Spatial description lets a signer represent relationships among objects. Establish the overall setting and maintain perspective as details are added. Depicting constructions require learned handshapes, movement, and grammar; they are not arbitrary pantomime.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt:
                    "Why establish the room before describing small objects?",
                choices: [
                  "It gives the details a spatial frame",
                  "It removes the need to use ASL grammar",
                  "It means perspective can change at random",
                ],
                correctChoice: 0,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Sketch a simple room mentally: doorway, table, chair. Plan a consistent viewpoint. Rehearse only spatial constructions you have been taught and note where you need a complete signed example.",
                prompt: "Can a viewer keep track of the doorway throughout?",
              ),
            ],
          ),
          Lesson(
            id: "showing-movement",
            title: "Showing movement",
            subtitle: "A path can carry meaning.",
            mode: LessonMode.camera,
            minutes: 8,
            xp: 40,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "ASL can depict how entities are located and move. The appropriate handshape depends on the construction and referent. Learn these forms from fluent signed examples with feedback instead of choosing any handshape that seems intuitive.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt:
                    "What should guide your choice of a depicting handshape?",
                choices: [
                  "The first letter of every English noun",
                  "The learned ASL construction and intended referent",
                  "Whichever shape looks most dramatic",
                ],
                correctChoice: 1,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Imagine a person walking past a stationary object. Plan the path and perspective. If you have learned the relevant construction, rehearse it in camera; otherwise use this as a scene-planning exercise for teacher review.",
                prompt:
                    "Does the path stay clear while the stationary object stays put?",
              ),
            ],
          ),
          Lesson(
            id: "this-one-or-that-one",
            title: "This one or that one?",
            subtitle: "Compare without losing the thread.",
            mode: LessonMode.recall,
            minutes: 7,
            xp: 35,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "Comparing two options requires clear referents and relevant differences. Spatial organization can support comparison when used consistently. Tell the viewer what each option is before returning to its established location.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt:
                    "You compare two apartments. What helps your partner follow?",
                choices: [
                  "Listing details without identifying the apartment",
                  "Consistent references and a few relevant differences",
                  "Changing the locations of both options repeatedly",
                ],
                correctChoice: 1,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Choose two fictional apartments: one near a park, one near a train station. Plan two consistent references and one advantage for each. Rehearse with structures already taught to you.",
                prompt:
                    "Can a viewer identify which apartment you prefer and why?",
              ),
            ],
          ),
        ],
      ),
      CourseUnit(
        id: "getting-things-done",
        title: "Getting things done",
        description:
            "Requests, directions, and small problems solved together.",
        lessons: [
          Lesson(
            id: "a-helpful-request",
            title: "A helpful request",
            subtitle: "Make the next step clear.",
            mode: LessonMode.conversation,
            minutes: 8,
            xp: 40,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "Requests work best when the other person can tell what help is needed. Establish the situation, request a specific action, and allow them to respond. Modify your request if they need more information.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt:
                    "You need help locating a book. Which information is most useful?",
                choices: [
                  "A request with no identifiable object",
                  "What you are looking for and the help you need",
                  "Every unrelated event from your day",
                ],
                correctChoice: 1,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Imagine asking library staff for a book you cannot find. Rehearse a short request with known vocabulary. Include a pause for clarification, then confirm what you understood.",
                prompt:
                    "What one detail would make your request easier to act on?",
              ),
            ],
          ),
          Lesson(
            id: "getting-there",
            title: "Getting there",
            subtitle: "Guide a friend one landmark at a time.",
            mode: LessonMode.camera,
            minutes: 9,
            xp: 45,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "Directions require a shared starting point and a consistent perspective. Break a route into manageable parts and check understanding. Signed direction-giving must be learned visually; English left/right instructions do not show all spatial grammar.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt: "Before giving a route, what should you establish?",
                choices: [
                  "The starting point and perspective",
                  "Only the final turn",
                  "A new viewpoint after every sentence",
                ],
                correctChoice: 0,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Plan a short route with two landmarks and one turn. Rehearse the spatial language you know. Pause at each landmark and check that a viewer would still know where they are.",
                prompt:
                    "Can you give the route again from the same starting perspective?",
              ),
            ],
          ),
          Lesson(
            id: "solve-it-together",
            title: "Solve it together",
            subtitle: "Stay connected when something goes wrong.",
            mode: LessonMode.story,
            minutes: 9,
            xp: 45,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "Your group arrives for a workshop and the room has changed. One person knows the new floor, another knows the room number. Bring the information together, clarify the missing part, and confirm the shared plan.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt: "What should the group do before heading off?",
                choices: [
                  "Combine and confirm the destination details",
                  "Follow whoever moves first without checking",
                  "Treat incomplete information as certain",
                ],
                correctChoice: 0,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Rehearse the problem, a focused question, and a proposed next step. Switch roles and imagine the other person adding a detail. This is a scripted rehearsal; a real partner supplies unpredictable responses.",
                prompt:
                    "Which question would most quickly resolve the uncertainty?",
              ),
            ],
          ),
        ],
      ),
    ],
  ),
  CourseLevel(
    id: "stories-in-motion",
    title: "Stories in motion",
    subtitle: "Intermediate",
    description:
        "Make experiences vivid with sequence, space, perspective, and expression. Build a story your audience can follow.",
    units: [
      CourseUnit(
        id: "a-story-worth-sharing",
        title: "A story worth sharing",
        description: "Set a scene, develop an event, and land the ending.",
        lessons: [
          Lesson(
            id: "set-the-scene",
            title: "Set the scene",
            subtitle: "Give your audience somewhere to stand.",
            mode: LessonMode.guided,
            minutes: 9,
            xp: 45,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "A clear narrative introduces relevant people, place, and time. Select details that help a viewer understand the event. Signed storytelling uses spatial and nonmanual resources alongside vocabulary and sequence.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt: "Which opening best prepares an audience for a story?",
                choices: [
                  "Begin with an unexplained reaction from an unknown person",
                  "List every object you have ever seen",
                  "Establish the setting and key people",
                ],
                correctChoice: 2,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Choose a true, low-stakes experience. Plan a short opening that identifies who, where, and when. Rehearse it with known ASL structures and notice whether the references stay clear.",
                prompt:
                    "What must the audience know before the main event begins?",
              ),
            ],
          ),
          Lesson(
            id: "then-something-happened",
            title: "Then something happened",
            subtitle: "Build the event in a clear sequence.",
            mode: LessonMode.camera,
            minutes: 9,
            xp: 45,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "Narrative events need an understandable order, including clear transitions when time or location changes. More detail is useful only when it helps the audience follow the event or understand its significance.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt:
                    "You return to an earlier event in your story. What does your audience need?",
                choices: [
                  "A clear signal that the time frame has shifted",
                  "A faster pace so they do not notice",
                  "No context until the story is finished",
                ],
                correctChoice: 0,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Plan an ordinary event with three beats: expectation, surprise, response. Rehearse at a comfortable pace and check that the sequence is clear. Mark one transition that needs educator feedback.",
                prompt: "Can a viewer retell the order of your three beats?",
              ),
            ],
          ),
          Lesson(
            id: "an-ending-that-lands",
            title: "An ending that lands",
            subtitle: "Give the story a satisfying close.",
            mode: LessonMode.story,
            minutes: 8,
            xp: 40,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "An ending can resolve the event or show why it mattered. It should connect to what the audience has already seen. Expression, timing, and a clear return to the narrator can help the viewer recognize the close.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt: "What makes an ending feel connected?",
                choices: [
                  "It resolves or reflects on the event you established",
                  "It introduces five unrelated characters",
                  "It contradicts earlier details without explanation",
                ],
                correctChoice: 0,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Return to your three-beat story. Add one short resolution or reflection using language you know. Rehearse the whole story, then consider whether every detail supports that ending.",
                prompt:
                    "What should the audience understand or feel at the close?",
              ),
            ],
          ),
        ],
      ),
      CourseUnit(
        id: "a-change-of-perspective",
        title: "A change of perspective",
        description:
            "Track characters, viewpoints, and grammatical expression.",
        lessons: [
          Lesson(
            id: "who-is-speaking",
            title: "Who is speaking?",
            subtitle: "Keep characters recognizable.",
            mode: LessonMode.guided,
            minutes: 9,
            xp: 45,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "Constructed dialogue and role shift can represent a character’s perspective. Body orientation, gaze, and expression work with context. Learn complete examples so character changes remain grammatical and easy to follow.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt:
                    "Before shifting into a character’s perspective, what helps?",
                choices: [
                  "Keeping all references unexplained",
                  "Establishing who the character is",
                  "Assuming every body movement identifies a new person",
                ],
                correctChoice: 1,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Plan a two-person exchange about a misplaced umbrella. Identify each character and map the turns. Rehearse role-shift patterns only if you have learned them from a fluent signer.",
                prompt: "Can you tell which character each turn belongs to?",
              ),
            ],
          ),
          Lesson(
            id: "show-the-reaction",
            title: "Show the reaction",
            subtitle: "Separate emotion from grammatical marking.",
            mode: LessonMode.camera,
            minutes: 9,
            xp: 45,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "Nonmanual features can serve different functions: marking grammar, showing affect, or representing a character’s behavior. Their timing and combination matter. A large facial expression is not automatically accurate or appropriate ASL.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt:
                    "What is a useful question when reviewing your expression?",
                choices: [
                  "What function does it serve, and does its timing fit?",
                  "Is it as exaggerated as possible?",
                  "Can it replace every sign I do not know?",
                ],
                correctChoice: 0,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Choose a reaction within the umbrella story. Rehearse the scene using learned structures. Notice when you are narrating and when you are representing the character; ask a teacher to review the distinction.",
                prompt: "Where does the reaction begin and end?",
              ),
            ],
          ),
          Lesson(
            id: "same-event-new-view",
            title: "Same event, new view",
            subtitle: "Retell without changing the facts.",
            mode: LessonMode.recall,
            minutes: 9,
            xp: 45,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "The same event can look different from another character’s viewpoint. A coherent retelling preserves the main facts while changing what the character knows, notices, and feels. Make viewpoint changes explicit.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt: "What should remain consistent across two viewpoints?",
                choices: [
                  "Only the number of signs used",
                  "The established facts of the event",
                  "Every character’s knowledge and feelings",
                ],
                correctChoice: 1,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Tell the umbrella story from the person who lost it, then the person who found it. Keep location and sequence consistent. Use only practiced perspective structures and note where feedback is needed.",
                prompt:
                    "What does each character know that the other does not?",
              ),
            ],
          ),
        ],
      ),
      CourseUnit(
        id: "the-missing-sketchbook",
        title: "The missing sketchbook",
        description:
            "Follow a three-part mystery through a familiar neighborhood.",
        lessons: [
          Lesson(
            id: "the-empty-table",
            title: "The empty table",
            subtitle: "Episode 1 · Something is missing.",
            mode: LessonMode.story,
            minutes: 10,
            xp: 50,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "Story premise: you left a sketchbook on the café table near the window. When you return, it is gone. A friend remembers someone carrying a book toward the door, but did not see its cover. Separate observation from assumption.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt: "What do you actually know from the friend’s account?",
                choices: [
                  "The café staff must know where it is",
                  "Someone carried a book; its identity is uncertain",
                  "The person definitely took your sketchbook",
                ],
                correctChoice: 1,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Rehearse the scene and the missing object with learned descriptive signs. Keep the table, window, and door consistent in space. Add a question that could clarify the book’s identity.",
                prompt:
                    "How can you describe what happened without overstating the evidence?",
              ),
            ],
          ),
          Lesson(
            id: "a-useful-clue",
            title: "A useful clue",
            subtitle: "Episode 2 · Ask the right question.",
            mode: LessonMode.conversation,
            minutes: 10,
            xp: 50,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "The café worker remembers moving a green notebook to lost property. Your sketchbook has a green cover and a small star sticker. The color matches, but you still need to confirm the distinguishing detail.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt: "Which follow-up best checks whether it is yours?",
                choices: [
                  "Ask about the star sticker or inspect the item",
                  "Assume every green book belongs to you",
                  "Ask an unrelated question about the weather",
                ],
                correctChoice: 0,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Rehearse a description of the distinguishing detail and a focused question. Imagine the worker asks you to repeat one part; respond with a clarification using familiar language.",
                prompt:
                    "Can you repair the detail without restarting the entire story?",
              ),
            ],
          ),
          Lesson(
            id: "the-story-you-tell",
            title: "The story you tell",
            subtitle: "Episode 3 · Bring the threads together.",
            mode: LessonMode.camera,
            minutes: 11,
            xp: 55,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "The notebook is your sketchbook. The worker moved it before cleaning the table. Retell the whole event: what you expected, what you first thought, what you learned, and how the mystery ended.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt: "What makes this retelling accurate?",
                choices: [
                  "Distinguishing your first assumption from what you later learned",
                  "Presenting the first guess as a proven fact",
                  "Leaving out the discovery that changed your understanding",
                ],
                correctChoice: 0,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Rehearse a complete retelling using scene-setting, consistent references, and learned perspective shifts. Self-review clarity and continuity. A fluent teacher should assess ASL grammar and comprehensibility.",
                prompt:
                    "Which moment changes the audience’s understanding of the story?",
              ),
            ],
          ),
        ],
      ),
    ],
  ),
  CourseLevel(
    id: "in-the-community",
    title: "In the community",
    subtitle: "Upper intermediate",
    description:
        "Follow longer exchanges, explore identity and variation, and participate thoughtfully in shared spaces.",
    units: [
      CourseUnit(
        id: "joining-the-conversation",
        title: "Joining the conversation",
        description: "Follow turns, opinions, and nuance in a group.",
        lessons: [
          Lesson(
            id: "a-place-in-the-circle",
            title: "A place in the circle",
            subtitle: "Follow more than one partner.",
            mode: LessonMode.guided,
            minutes: 10,
            xp: 50,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "Group conversation involves tracking participants, visual access, and turns. Attend to the current signer and notice cues that a turn is opening. Position yourself so you can follow others without blocking their view.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt: "What supports a visually accessible group exchange?",
                choices: [
                  "Signing over someone whenever you have an idea",
                  "Standing where others cannot see each other",
                  "Clear sightlines and attention to turn-taking cues",
                ],
                correctChoice: 2,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Imagine a group of three discussing a weekend activity. Map the speakers and plan how you would follow each turn. Rehearse a brief contribution that connects to the previous idea.",
                prompt:
                    "Where would you position yourself so everyone can see?",
              ),
            ],
          ),
          Lesson(
            id: "agree-and-add",
            title: "Agree and add",
            subtitle: "Show you understood before moving forward.",
            mode: LessonMode.conversation,
            minutes: 10,
            xp: 50,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "A meaningful contribution responds to the point being made. You can acknowledge an idea, add an example, or ask a clarifying question. Repeating a memorized opinion without responding is not the same as conversational fluency.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt:
                    "A partner suggests moving the event outdoors. Which response engages with their idea?",
                choices: [
                  "Agree automatically without understanding",
                  "Ask about weather and visual access, then add your view",
                  "Recite an unrelated prepared speech",
                ],
                correctChoice: 1,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Choose one advantage and one question about an outdoor event. Rehearse a connected response with learned ASL structures. Leave time for your partner to answer the question.",
                prompt:
                    "Does your contribution connect to the idea you received?",
              ),
            ],
          ),
          Lesson(
            id: "disagree-with-care",
            title: "Disagree with care",
            subtitle: "Keep the conversation open.",
            mode: LessonMode.camera,
            minutes: 10,
            xp: 50,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "Disagreement can be clear and respectful. Establish the idea you are responding to, state your view, and support it with relevant reasons. Attend to register and your relationship with the people in the conversation.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt: "What makes a disagreement easier to discuss?",
                choices: [
                  "A clear position, relevant reasons, and room for response",
                  "Assumptions about the other person’s motives",
                  "Changing their argument into a different claim",
                ],
                correctChoice: 0,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Rehearse a response to the outdoor-event proposal. Acknowledge the benefit, explain a concern, and suggest an alternative. Ask a fluent teacher whether your register and expression fit the situation.",
                prompt:
                    "Can someone disagree with you and still remain part of the exchange?",
              ),
            ],
          ),
        ],
      ),
      CourseUnit(
        id: "language-and-identity",
        title: "Language and identity",
        description:
            "Learn from community perspectives and language variation.",
        lessons: [
          Lesson(
            id: "many-ways-to-belong",
            title: "Many ways to belong",
            subtitle: "Identity is personal.",
            mode: LessonMode.story,
            minutes: 10,
            xp: 50,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "Deaf communities include people with varied identities, backgrounds, language histories, and access needs. One person’s experience does not represent everyone. Learn directly from multiple Deaf voices and use the terms people choose for themselves.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt:
                    "Two Deaf people describe different communication preferences. What does that tell you?",
                choices: [
                  "Preferences differ and should be respected individually",
                  "One of them must be mistaken about their identity",
                  "You should choose one rule for everyone",
                ],
                correctChoice: 0,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Reflect on an assumption you have revised while learning. Rehearse a short account using known language without speaking for a community. Identify a Deaf-created resource you would like to learn from next.",
                prompt:
                    "How can you make room for experiences different from your own?",
              ),
            ],
          ),
          Lesson(
            id: "variation-is-language",
            title: "Variation is language",
            subtitle: "Recognize more than one valid form.",
            mode: LessonMode.recall,
            minutes: 10,
            xp: 50,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "ASL varies across regions, generations, and communities. A form that differs from your first classroom example is not automatically wrong. Learn the context and community of use, and avoid treating one signer as the only standard.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt:
                    "You encounter a sign variant you have not seen before. What is a useful response?",
                choices: [
                  "Declare it incorrect because your app used another form",
                  "Copy it into every context without understanding it",
                  "Ask about its meaning and context of use",
                ],
                correctChoice: 2,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Choose a word for which your teacher has shown more than one variant. Rehearse the versions with their contexts. If you do not know one yet, prepare a question for a Deaf educator rather than inventing a variant.",
                prompt:
                    "What context would you record alongside a new variant?",
              ),
            ],
          ),
          Lesson(
            id: "learning-with-people",
            title: "Learning with people",
            subtitle: "Build relationships, not just a streak.",
            mode: LessonMode.conversation,
            minutes: 11,
            xp: 55,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "Real interaction develops skills that a solo app cannot supply: unexpected responses, different signers, negotiation, and relationships. Choose learning spaces that welcome your participation and respect the time, boundaries, and expertise of community members.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt: "What is a respectful way to seek sustained feedback?",
                choices: [
                  "Assume every Deaf person owes you corrections",
                  "Record strangers signing without asking",
                  "Arrange instruction or a mutually agreed practice exchange",
                ],
                correctChoice: 2,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Prepare a short introduction for a teacher or an agreed practice partner. State a specific learning goal and ask how they prefer to structure feedback. Keep any video sharing separate and consensual.",
                prompt:
                    "What would make the exchange useful and comfortable for both people?",
              ),
            ],
          ),
        ],
      ),
      CourseUnit(
        id: "community-in-action",
        title: "Community in action",
        description: "Plan something together and communicate through changes.",
        lessons: [
          Lesson(
            id: "a-shared-plan",
            title: "A shared plan",
            subtitle: "Bring a community event to life.",
            mode: LessonMode.story,
            minutes: 11,
            xp: 55,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "Scenario: a small group is planning an art afternoon. You need an accessible layout, a schedule, supplies, and clear responsibilities. Gather people’s actual preferences instead of assuming one arrangement works for everyone.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt: "How should the group decide on communication access?",
                choices: [
                  "Assume one person can speak for everyone",
                  "Wait until people arrive before considering it",
                  "Ask participants about preferences and arrange support accordingly",
                ],
                correctChoice: 2,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Rehearse a proposal covering purpose, place, and one responsibility. Use consistent references for people and tasks. Add a question inviting input before the group commits to the plan.",
                prompt:
                    "What decision needs participation from the people affected?",
              ),
            ],
          ),
          Lesson(
            id: "when-details-shift",
            title: "When details shift",
            subtitle: "Update the group without confusion.",
            mode: LessonMode.camera,
            minutes: 11,
            xp: 55,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "The art room is unavailable, and the event moves to a larger studio. Explain what changed, what remains the same, and which people need to act. A useful update separates confirmed details from open questions.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt: "Which update is clearest?",
                choices: [
                  "Mention several locations without confirming one",
                  "Treat an unconfirmed possibility as settled",
                  "Identify the new location, unchanged time, and any action needed",
                ],
                correctChoice: 2,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Rehearse the update, then imagine someone missed the location change. Clarify just that part. Review whether your references and time frame remain consistent across the repair.",
                prompt:
                    "Would a late arrival know where to go and what to bring?",
              ),
            ],
          ),
          Lesson(
            id: "a-conversation-that-matters",
            title: "A conversation that matters",
            subtitle: "Reflect, respond, and build understanding.",
            mode: LessonMode.conversation,
            minutes: 12,
            xp: 60,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "After the event, participants share what worked and what could improve. Summarize a point accurately before adding your perspective. Check your interpretation when an experience differs from your own.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt:
                    "Someone describes an access barrier you did not notice. What helps?",
                choices: [
                  "Dismiss it because the event seemed fine to you",
                  "Assume you already understand all the details",
                  "Clarify their experience and discuss a useful next step",
                ],
                correctChoice: 2,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Rehearse a short reflection on the fictional event, a clarifying question, and a proposed improvement. With a real partner, let their response change the direction of the conversation.",
                prompt: "What did you learn that should change the next event?",
              ),
            ],
          ),
        ],
      ),
    ],
  ),
  CourseLevel(
    id: "beyond-the-familiar",
    title: "Beyond the familiar",
    subtitle: "Advanced practice",
    description:
        "Work toward nuanced, spontaneous communication through complex ideas, ASL expression, and sustained feedback from fluent people.",
    units: [
      CourseUnit(
        id: "ideas-with-depth",
        title: "Ideas with depth",
        description:
            "Explain a process, support a position, and explore possibilities.",
        lessons: [
          Lesson(
            id: "make-it-understandable",
            title: "Make it understandable",
            subtitle: "Explain something you know well.",
            mode: LessonMode.guided,
            minutes: 12,
            xp: 60,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "An extended explanation needs organization, examples, and attention to the audience’s background. Complex ASL draws on grammatical and discourse resources beyond vocabulary. Check understanding and rephrase when your first explanation does not land.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt:
                    "Your partner knows little about your topic. What helps them follow?",
                choices: [
                  "Repeat the same explanation louder or faster",
                  "Establish needed concepts and build with examples",
                  "Use unexplained specialist terms as quickly as possible",
                ],
                correctChoice: 1,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Choose a familiar process with three stages. Rehearse an overview, an example, and a check for understanding using ASL structures you have learned. Request fluent feedback on clarity and grammar.",
                prompt:
                    "Which concept must the audience understand before the next stage?",
              ),
            ],
          ),
          Lesson(
            id: "a-case-worth-making",
            title: "A case worth making",
            subtitle: "Support an opinion with reasons.",
            mode: LessonMode.camera,
            minutes: 12,
            xp: 60,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "A persuasive explanation distinguishes a position, supporting evidence, and an example. Represent other viewpoints fairly. Expressing nuance also means showing the limits of your claim and adjusting when new information matters.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt:
                    "What strengthens an argument about a community project?",
                choices: [
                  "Treating personal preference as a universal fact",
                  "Misrepresenting the opposing view",
                  "Relevant evidence and fair treatment of alternatives",
                ],
                correctChoice: 2,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Pick a low-stakes proposal, such as extending library hours. Rehearse your view, two reasons, and a response to one concern. Ask a fluent reviewer to assess coherence, register, and grammatical control.",
                prompt: "What evidence could reasonably change your view?",
              ),
            ],
          ),
          Lesson(
            id: "what-if",
            title: "What if?",
            subtitle: "Explore a possibility without losing the facts.",
            mode: LessonMode.conversation,
            minutes: 12,
            xp: 60,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "Hypothetical discussion distinguishes what is known from what is imagined. Conditional constructions and discourse cues help track that distinction. Learn their full signed form and timing through advanced instruction.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt:
                    "You imagine a town with no cars downtown. What should your audience understand?",
                choices: [
                  "That the change has already happened",
                  "That every predicted effect is certain",
                  "That this is a hypothetical scenario",
                ],
                correctChoice: 2,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Plan a hypothetical change, one possible benefit, and one uncertainty. Rehearse conditional forms you have been taught. Let an imagined partner challenge one assumption and revise your response.",
                prompt:
                    "Where do you move from an established fact into a possibility?",
              ),
            ],
          ),
        ],
      ),
      CourseUnit(
        id: "art-and-expression",
        title: "Art and expression",
        description:
            "Explore storytelling craft, register, and ASL literature.",
        lessons: [
          Lesson(
            id: "a-language-of-art",
            title: "A language of art",
            subtitle: "Learn from ASL creators.",
            mode: LessonMode.story,
            minutes: 12,
            xp: 60,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "ASL literature includes storytelling, poetry, and performance traditions. Its visual and linguistic craft should be studied through Deaf creators’ actual work, with attribution and appropriate permissions. A written summary cannot replace the signed work.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt: "How should you approach an ASL artist’s performance?",
                choices: [
                  "Watch the original work, credit the creator, and study its context",
                  "Treat an English summary as the complete artwork",
                  "Repost or imitate a full performance without regard for permission",
                ],
                correctChoice: 0,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Choose an appropriately available work by a Deaf creator. Note one use of rhythm, space, or perspective that you want to understand. Reflect using familiar ASL rather than reproducing the artist’s work.",
                prompt:
                    "What question about the craft would you bring to an educator?",
              ),
            ],
          ),
          Lesson(
            id: "change-the-register",
            title: "Change the register",
            subtitle: "One idea, different audiences.",
            mode: LessonMode.camera,
            minutes: 12,
            xp: 60,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "Language choices shift with audience, setting, and purpose. A casual story to a friend and a formal presentation may differ in organization, detail, and delivery. Study authentic examples rather than equating formality with stiffness.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt: "What should guide how you adapt a presentation?",
                choices: [
                  "A rule that faster signing is always more advanced",
                  "Using identical delivery in every situation",
                  "Audience, purpose, setting, and feedback",
                ],
                correctChoice: 2,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Rehearse a short event invitation for a friend, then for a community meeting. Keep the facts the same. Ask a fluent teacher which changes in register are appropriate and which feel unnatural.",
                prompt:
                    "What changes because of the audience, and what should remain clear?",
              ),
            ],
          ),
          Lesson(
            id: "tell-it-your-way",
            title: "Tell it your way",
            subtitle: "Develop an original signed narrative.",
            mode: LessonMode.recall,
            minutes: 13,
            xp: 65,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "An original story draws on your experiences and learned language. Revise for coherence, perspective, pacing, and meaningful detail. Craft grows through viewing fluent work and receiving specific feedback, not merely adding more elaborate movement.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt: "Which revision is most useful?",
                choices: [
                  "Add movement everywhere regardless of meaning",
                  "Remove all pauses to appear fluent",
                  "Clarify the moment a viewer could not follow",
                ],
                correctChoice: 2,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Revisit a personal story from an earlier level. Plan a more developed version with a clear point of view. Rehearse and identify one specific question for a fluent reviewer rather than assigning yourself a proficiency score.",
                prompt:
                    "Which revision would most improve the audience’s understanding?",
              ),
            ],
          ),
        ],
      ),
      CourseUnit(
        id: "your-next-chapter",
        title: "Your next chapter",
        description: "Build a portfolio and a sustainable path toward fluency.",
        lessons: [
          Lesson(
            id: "the-unexpected-follow-up",
            title: "The unexpected follow-up",
            subtitle: "Move beyond the prepared response.",
            mode: LessonMode.conversation,
            minutes: 13,
            xp: 65,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "Spontaneous communication includes understanding unfamiliar turns, repairing misunderstandings, and adapting your message. A scripted solo scenario can prepare you, but it cannot demonstrate that you can follow an unpredictable signed conversation.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt:
                    "What provides evidence beyond rehearsing a memorized script?",
                choices: [
                  "Interaction with a fluent partner who asks unplanned questions",
                  "Repeating the same script until it feels fast",
                  "Completing every multiple-choice question in an app",
                ],
                correctChoice: 0,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Choose a familiar topic and imagine three unexpected follow-up questions. Rehearse how you would ask for clarification. Arrange real practice with an agreed partner when you are ready.",
                prompt:
                    "Which question would stretch you beyond memorized language?",
              ),
            ],
          ),
          Lesson(
            id: "a-portfolio-with-purpose",
            title: "A portfolio with purpose",
            subtitle: "Gather evidence of growth.",
            mode: LessonMode.camera,
            minutes: 14,
            xp: 70,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "A useful portfolio includes different communicative tasks and feedback over time: a narrative, an explanation, and an interaction where everyone consents to recording. Self-reflection and teacher assessment serve different purposes.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt: "What should a learning portfolio demonstrate?",
                choices: [
                  "A fluency guarantee based on a streak",
                  "Varied communication and specific growth after feedback",
                  "Only a large number of practice attempts",
                ],
                correctChoice: 1,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Plan one narrative, one explanation, and one agreed conversation sample. Rehearse your narrative here; separately decide how to obtain teacher feedback and handle any recordings with consent.",
                prompt:
                    "What would you like a fluent reviewer to compare across your samples?",
              ),
            ],
          ),
          Lesson(
            id: "keep-the-conversation-going",
            title: "Keep the conversation going",
            subtitle: "Learning continues in real life.",
            mode: LessonMode.guided,
            minutes: 12,
            xp: 60,
            steps: [
              LessonStep(
                title: "Make the connection",
                body:
                    "Course completion is a milestone in participation, not proof of fluency or interpreter qualification. Sustained interaction, receptive practice with varied signers, and qualified feedback are essential. Independent proficiency evaluation is a separate process.",
                prompt: "Take a moment to picture this in a real conversation.",
              ),
              LessonStep(
                title: "Notice the difference",
                body:
                    "Choose the response that best fits this situation. This checks the idea, not your signing.",
                prompt:
                    "After completing this learning path, what is the most useful next step?",
                choices: [
                  "Assume app completion certifies fluency",
                  "Stop receptive practice because all units are checked",
                  "Set goals with a fluent educator and keep interacting with people",
                ],
                correctChoice: 2,
              ),
              LessonStep(
                title: "Make it your own",
                body:
                    "Name one communicative strength, one recurring difficulty, and one real setting you want to participate in. Rehearse that reflection and use it to plan your next learning cycle with a teacher.",
                prompt:
                    "What conversation do you want to be able to join next?",
              ),
            ],
          ),
        ],
      ),
    ],
  ),
];

Lesson get starterLesson => courseLevels.first.units.first.lessons.first;

List<Lesson> get allLessons => List<Lesson>.unmodifiable(
  courseLevels.expand((level) => level.units).expand((unit) => unit.lessons),
);
