/// Authored program manifest: 72 differentiated units, pending Deaf review.
/// Source links ground principles; they do not license media or imply approval.
/// English vocabulary labels are concept targets, not canonical ASL glosses.
class ProgramBandBlueprint {
  const ProgramBandBlueprint({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.units,
  });
  final String id, title, subtitle, description;
  final List<ProgramUnitBlueprint> units;
}

class ProgramUnitBlueprint {
  const ProgramUnitBlueprint({
    required this.id,
    required this.title,
    required this.objectives,
    required this.vocabulary,
    required this.grammarFocus,
    required this.cultureFocus,
    required this.receptiveTask,
    required this.expressiveTask,
    required this.scenario,
    required this.partnerA,
    required this.partnerB,
    required this.transferTwist,
    required this.conceptQuestion,
    required this.conceptAnswers,
    required this.rubric,
    required this.prerequisiteIds,
    required this.referenceUrls,
    this.educatorReviewStatus = 'Pending Deaf educator review',
    this.mediaStatus = 'Reference signer media not yet supplied',
    this.assessmentStatus =
        'Rubric proposed; not a validated proficiency measure',
  });
  final String id, title, grammarFocus, cultureFocus;
  final String receptiveTask, expressiveTask, scenario, partnerA, partnerB;
  final String transferTwist, conceptQuestion;
  final List<String> objectives, vocabulary, conceptAnswers, rubric;
  final List<String> prerequisiteIds, referenceUrls;
  final String educatorReviewStatus, mediaStatus, assessmentStatus;
}

const programActivityKinds = <String>[
  'observe',
  'comprehension',
  'grammar',
  'expressive',
  'retrieval',
  'information_gap',
  'story',
  'checkpoint',
];

const List<ProgramBandBlueprint> programBands = [
  ProgramBandBlueprint(
    id: "first-connections",
    title: "First connections",
    subtitle: "Absolute beginner",
    description:
        "Build visual attention, legible beginnings, everyday repair, and respect for the people whose language you are learning.",
    units: [
      ProgramUnitBlueprint(
        id: "hello-world",
        title: "Hello, world",
        objectives: [
          "Establish shared visual attention",
          "Open and close a brief exchange",
        ],
        vocabulary: [
          "greeting",
          "acknowledgment",
          "attention",
          "goodbye",
          "turn",
        ],
        grammarFocus:
            "Attention and a visible turn boundary make a greeting an exchange; an English label does not specify a complete signed utterance.",
        cultureFocus:
            "Respect someone’s attention and willingness to interact. A greeting does not create an obligation to teach.",
        receptiveTask:
            "With a fluent model, distinguish a greeting offered before attention from a greeting received and acknowledged.",
        expressiveTask:
            "Rehearse a relaxed greeting, allow a reply, and make the ending recognizable.",
        scenario:
            "You reach a welcome desk while a volunteer is arranging name cards.",
        partnerA:
            "You want to know when check-in opens; you have not greeted the volunteer yet.",
        partnerB:
            "You are the volunteer; check-in opens in five minutes, and you need to finish one card.",
        transferTwist:
            "The volunteer acknowledges you but asks for a moment before continuing.",
        conceptQuestion:
            "What turns a greeting attempt into the start of a shared exchange?",
        conceptAnswers: [
          "The other person has visual access and a chance to acknowledge or respond.",
          "Completing the greeting quickly is enough even when the other person looks away.",
          "Repeating the greeting continuously guarantees that a turn has begun.",
        ],
        rubric: [
          "Establishes attention without interrupting unnecessarily",
          "Leaves room for acknowledgment",
          "Signals a clear close",
        ],
        prerequisiteIds: [],
        referenceUrls: [
          "https://nad.org/knowledge-hub/american-sign-language/learning-american-sign-language/",
          "https://www.lifeprint.com/asl101/curriculum/curriculum.htm",
          "https://www.lifeprint.com/asl101/pages-signs/h/hello.htm",
        ],
      ),
      ProgramUnitBlueprint(
        id: "seeing-clearly",
        title: "Seeing clearly",
        objectives: [
          "Set up a usable signing view",
          "Notice whole-signer information",
        ],
        vocabulary: [
          "face",
          "hands",
          "upper body",
          "lighting",
          "framing",
          "comfort",
        ],
        grammarFocus:
            "Handshape, orientation, location, movement, and nonmanual features work together. Cropping any one can remove information.",
        cultureFocus:
            "Adapt the setup to the learner’s body and access needs rather than judging a single posture.",
        receptiveTask:
            "Compare two authorized views of the same utterance and identify what a face-only or hand-only crop hides.",
        expressiveTask:
            "Move within a comfortable signing space and adjust the camera so face and both hands remain visible.",
        scenario:
            "A practice partner can see your face, but your hands disappear near the bottom of the call.",
        partnerA:
            "Your preview looks clear at rest; ask what disappears during movement.",
        partnerB:
            "You can see the face but lose the non-dominant hand during the final movement.",
        transferTwist:
            "A bright window behind you makes the hands difficult to distinguish.",
        conceptQuestion: "What should a usable practice view preserve?",
        conceptAnswers: [
          "The face, both hands, and relevant upper-body movement throughout the utterance.",
          "Only the dominant hand, because the other hand is always optional.",
          "Only the face, because a written vocabulary label supplies the hand movement.",
        ],
        rubric: [
          "Maintains a complete comfortable frame",
          "Identifies information lost by a crop",
          "Adjusts the view after specific feedback",
        ],
        prerequisiteIds: ["hello-world"],
        referenceUrls: [
          "https://nad.org/knowledge-hub/american-sign-language/learning-american-sign-language/",
          "https://www.lifeprint.com/asl101/curriculum/curriculum.htm",
        ],
      ),
      ProgramUnitBlueprint(
        id: "fingerspelling-foundations",
        title: "Fingerspelling foundations",
        objectives: [
          "Distinguish letter forms in reviewed models",
          "Practice legibility before speed",
        ],
        vocabulary: [
          "manual alphabet",
          "handshape",
          "orientation",
          "letter",
          "transition",
          "dominant hand",
        ],
        grammarFocus:
            "Letters have form and orientation; J and Z involve movement. Learn the complete alphabet from reviewed visual models, not invented text descriptions.",
        cultureFocus:
            "Fingerspelling is part of ASL, not a substitute for learning its grammar and vocabulary.",
        receptiveTask:
            "Match short, educator-selected letter sequences to choices after watching the full sequence once.",
        expressiveTask:
            "Practice three personally relevant letters and their transitions using a verified alphabet model.",
        scenario:
            "You need to spell a fictional badge code clearly to a practice partner.",
        partnerA:
            "Your code is M-A-X; communicate it without displaying the written card.",
        partnerB:
            "You have M-A-X and M-A-Y badge options; ask about the final letter.",
        transferTwist:
            "The partner understands each letter separately but loses the transition.",
        conceptQuestion: "What is a productive early fingerspelling goal?",
        conceptAnswers: [
          "Clear learned letter forms with comfortable, connected transitions.",
          "A separate large arm movement for every letter to make spelling look emphatic.",
          "Maximum speed before the partner can distinguish the sequence.",
        ],
        rubric: [
          "Forms selected letters from a reviewed model",
          "Maintains useful orientation",
          "Responds to a request to repeat a transition",
        ],
        prerequisiteIds: ["seeing-clearly"],
        referenceUrls: [
          "https://nad.org/knowledge-hub/american-sign-language/learning-american-sign-language/",
          "https://www.lifeprint.com/asl101/curriculum/curriculum.htm",
        ],
      ),
      ProgramUnitBlueprint(
        id: "fingerspelling-in-words",
        title: "Names have a rhythm",
        objectives: [
          "Recognize short words as sequences",
          "Repair a partially understood name",
        ],
        vocabulary: [
          "name",
          "word shape",
          "rhythm",
          "double letter",
          "replay",
          "clarification",
        ],
        grammarFocus:
            "Fingerspelling comprehension develops beyond isolated-letter naming. Context helps, but a plausible guess remains a guess until confirmed.",
        cultureFocus:
            "Respect people’s names. Do not replace an unfamiliar name with a more convenient one.",
        receptiveTask:
            "Watch short names from different approved signers, then identify the sequence and mark any uncertain segment.",
        expressiveTask:
            "Fingerspell a fictional name at a legible pace and repeat only the part a partner requests.",
        scenario:
            "You meet someone named Ari but are unsure whether the final letter was I or Y.",
        partnerA: "You heard A-R and want to confirm the ending.",
        partnerB: "Your fictional name is A-R-I; clarify the ending if asked.",
        transferTwist:
            "The next name contains a repeated letter that needs its own modeled convention.",
        conceptQuestion:
            "You infer a name from context but miss its ending. What should you do?",
        conceptAnswers: [
          "Confirm the uncertain part instead of treating your inference as fact.",
          "Use the more common spelling because context always resolves the final letter.",
          "Ask the person to choose a shorter name for the exercise.",
        ],
        rubric: [
          "Recognizes a short complete sequence",
          "Identifies an uncertain segment",
          "Repairs the segment without changing the person’s name",
        ],
        prerequisiteIds: ["fingerspelling-foundations"],
        referenceUrls: [
          "https://nad.org/knowledge-hub/american-sign-language/learning-american-sign-language/",
          "https://www.lifeprint.com/asl101/curriculum/curriculum.htm",
        ],
      ),
      ProgramUnitBlueprint(
        id: "your-first-connections",
        title: "Your first connections",
        objectives: [
          "Introduce yourself and receive an introduction",
          "Ask for repetition when needed",
        ],
        vocabulary: [
          "name",
          "learn",
          "meet",
          "introduction",
          "again",
          "understand",
        ],
        grammarFocus:
            "Introductions have reciprocal turns. A name, a reference to self, and a question must be learned as contextual signed utterances.",
        cultureFocus:
            "Name signs carry community context; fingerspell your name rather than inventing a name sign for yourself.",
        receptiveTask:
            "Identify who is introducing whom in a short reviewed exchange; distinguish a name from a follow-up question.",
        expressiveTask:
            "Offer a greeting, share a practiced name, receive the other name, and clarify one detail.",
        scenario:
            "At a beginner group, you and a new partner exchange names and explain that you are learning.",
        partnerA:
            "You know your own name but need the partner’s name and learning background.",
        partnerB:
            "You are Sam and this is your second class; ask whether your partner is new.",
        transferTwist:
            "Your partner has a longer name than the names in your earlier practice.",
        conceptQuestion:
            "How should a learner introduce an unfamiliar personal name?",
        conceptAnswers: [
          "Use learned fingerspelling and clarify the name when needed.",
          "Invent a convenient name sign without community context.",
          "Skip the name because introductions only require a greeting.",
        ],
        rubric: [
          "Keeps the introduction reciprocal",
          "Clarifies an unfamiliar name",
          "Uses only names and forms actually learned",
        ],
        prerequisiteIds: ["fingerspelling-in-words"],
        referenceUrls: [
          "https://nad.org/knowledge-hub/american-sign-language/learning-american-sign-language/",
          "https://www.lifeprint.com/asl101/curriculum/curriculum.htm",
        ],
      ),
      ProgramUnitBlueprint(
        id: "numbers-one-ten",
        title: "Small numbers, clear meaning",
        objectives: [
          "Recognize small quantities in context",
          "Confirm a quantity without guessing",
        ],
        vocabulary: [
          "one to ten",
          "quantity",
          "how many",
          "count",
          "total",
          "confirmation",
        ],
        grammarFocus:
            "Number production depends on use. Learn a quantity example separately from a sequence of digits; do not transfer orientation rules indiscriminately.",
        cultureFocus:
            "Accuracy matters more than a speed score when exchanging quantities.",
        receptiveTask:
            "Match reviewed quantity utterances to groups of objects, then distinguish quantity from an identifying digit.",
        expressiveTask:
            "Communicate quantities for three sets of classroom supplies using approved number models.",
        scenario:
            "You and a partner divide supplies for a small table activity.",
        partnerA:
            "You have four markers and need six in total; ask for the missing quantity.",
        partnerB:
            "You have two spare markers and three spare pencils; clarify which supply is needed.",
        transferTwist:
            "The partner interprets the number as a table label rather than a quantity.",
        conceptQuestion: "Why establish what a number refers to?",
        conceptAnswers: [
          "A quantity and an identifying digit can serve different communicative functions.",
          "The number alone always identifies the object and the purpose.",
          "All contexts require exactly the same number production conventions.",
        ],
        rubric: [
          "Identifies the quantity and its referent",
          "Uses an approved contextual number form",
          "Confirms the exchanged total",
        ],
        prerequisiteIds: ["your-first-connections"],
        referenceUrls: [
          "https://www.lifeprint.com/asl101/pages-layout/grammar.htm",
          "https://www.rit.edu/ntid/slpi",
          "https://www.lifeprint.com/asl101/pages-layout/numericalincorporation.htm",
        ],
      ),
      ProgramUnitBlueprint(
        id: "yes-no-questions",
        title: "Questions that invite yes or no",
        objectives: [
          "Recognize a yes/no question in context",
          "Coordinate a practiced question and response",
        ],
        vocabulary: ["yes", "no", "question", "answer", "ready", "want"],
        grammarFocus:
            "Yes/no question marking involves nonmanual grammar and its timing across the utterance; it is not an eyebrow gesture added after arbitrary English word order.",
        cultureFocus:
            "A question invites a real response, including a refusal or a request for clarification.",
        receptiveTask:
            "Compare approved statements and yes/no questions with similar vocabulary; attend to the complete face and body.",
        expressiveTask:
            "Practice a learned readiness or preference question and pause long enough for the response.",
        scenario:
            "You want to know whether a partner is ready to begin a practice round.",
        partnerA:
            "You are ready but need to check the partner before starting.",
        partnerB:
            "You need another minute; communicate that and confirm when to start.",
        transferTwist:
            "The partner answers with a clarification rather than a simple yes.",
        conceptQuestion:
            "What must a learner study when learning a yes/no question?",
        conceptAnswers: [
          "The complete signed question, including the timing of its nonmanual marking.",
          "Only a final English question word added to any statement.",
          "An isolated facial pose independent of the signed utterance.",
        ],
        rubric: [
          "Distinguishes a question from a statement",
          "Coordinates learned nonmanual timing",
          "Waits for and responds to the answer",
        ],
        prerequisiteIds: ["numbers-one-ten"],
        referenceUrls: [
          "https://www.lifeprint.com/asl101/pages-layout/grammar.htm",
          "https://www.rit.edu/ntid/slpi",
        ],
      ),
      ProgramUnitBlueprint(
        id: "wh-questions",
        title: "Ask for the missing piece",
        objectives: [
          "Identify the information a question requests",
          "Form a focused clarification",
        ],
        vocabulary: ["who", "what", "where", "when", "which", "information"],
        grammarFocus:
            "Information questions differ in purpose from yes/no questions. Learn grammatical form and nonmanual scope through complete contextual examples.",
        cultureFocus:
            "Ask only for information relevant to the exchange; curiosity does not override personal boundaries.",
        receptiveTask:
            "Match reviewed information questions to the kind of answer requested, not merely to a familiar isolated sign.",
        expressiveTask:
            "Ask one learned question about a missing location or person and follow the answer.",
        scenario:
            "A workshop announcement mentions a meeting but you missed its location.",
        partnerA: "You know the meeting is today and need the room.",
        partnerB:
            "The room is Studio B; if asked about time, explain that time is already confirmed.",
        transferTwist:
            "The answer contains a place name you have not encountered before.",
        conceptQuestion: "Which question best repairs a missed location?",
        conceptAnswers: [
          "A focused request for the place where the meeting will occur.",
          "A yes/no question about whether any meeting exists.",
          "A request to repeat every detail even though only the location is unclear.",
        ],
        rubric: [
          "Identifies the missing information type",
          "Asks a relevant learned question",
          "Checks an unfamiliar answer",
        ],
        prerequisiteIds: ["yes-no-questions"],
        referenceUrls: [
          "https://www.lifeprint.com/asl101/pages-layout/grammar.htm",
          "https://www.rit.edu/ntid/slpi",
        ],
      ),
      ProgramUnitBlueprint(
        id: "pointing-and-possession",
        title: "People, objects, and reference",
        objectives: [
          "Establish a referent before returning to it",
          "Distinguish a person from their possession",
        ],
        vocabulary: [
          "I",
          "you",
          "person",
          "object",
          "mine",
          "yours",
          "reference",
        ],
        grammarFocus:
            "Indexing and possessive forms have distinct functions. A location in signing space gains reference through context, not from pointing anywhere at random.",
        cultureFocus:
            "Pointing in signed discourse should not be judged by unrelated spoken-language etiquette rules.",
        receptiveTask:
            "Track which person and which belonging are referenced in an approved two-person exchange.",
        expressiveTask:
            "Introduce two people and identify one belonging of each using forms already modeled.",
        scenario: "Two learners have left similar notebooks on a shared desk.",
        partnerA:
            "Your notebook has a green sticker; ask which notebook belongs to the partner.",
        partnerB:
            "Your notebook has a blue sticker; the unmarked notebook belongs to the teacher.",
        transferTwist:
            "A third notebook appears and needs a newly established referent.",
        conceptQuestion: "What makes a reference understandable to a partner?",
        conceptAnswers: [
          "A clearly established person or object and consistent subsequent reference.",
          "A new arbitrary location each time the same person is mentioned.",
          "Assuming pointing and possession always use the same form.",
        ],
        rubric: [
          "Establishes each referent",
          "Keeps person and possession distinct",
          "Maintains references when a new object appears",
        ],
        prerequisiteIds: ["wh-questions"],
        referenceUrls: [
          "https://www.lifeprint.com/asl101/pages-layout/grammar.htm",
          "https://www.rit.edu/ntid/slpi",
        ],
      ),
      ProgramUnitBlueprint(
        id: "preferences-and-negation",
        title: "Likes, dislikes, and a clear no",
        objectives: [
          "Express a familiar preference",
          "Recognize what is being negated",
        ],
        vocabulary: ["like", "dislike", "want", "not", "prefer", "choice"],
        grammarFocus:
            "Negation can involve manual and nonmanual elements with meaningful scope. Study what part of the utterance is negated rather than attaching a generic no to everything.",
        cultureFocus:
            "Respect a partner’s no without requiring an explanation they do not wish to give.",
        receptiveTask:
            "Identify whether a reviewed utterance rejects an item, a time, or the whole proposed activity.",
        expressiveTask:
            "Express one preference and one respectful refusal using learned contextual forms.",
        scenario:
            "A partner offers tea before a practice meeting; you want water instead.",
        partnerA:
            "You do not want tea but would like water; make the distinction clear.",
        partnerB: "You can offer tea or water and need to know which to bring.",
        transferTwist:
            "The partner thinks you declined the meeting rather than the drink.",
        conceptQuestion:
            "What needs clarification when a negative response is misunderstood?",
        conceptAnswers: [
          "Which item or proposition the negation applies to.",
          "That any negative response rejects the entire interaction.",
          "That facial marking can be omitted whenever a manual sign is used.",
        ],
        rubric: [
          "Expresses an understandable preference",
          "Makes the scope of refusal clear",
          "Repairs a mistaken interpretation",
        ],
        prerequisiteIds: ["pointing-and-possession"],
        referenceUrls: [
          "https://www.lifeprint.com/asl101/pages-layout/grammar.htm",
          "https://www.rit.edu/ntid/slpi",
        ],
      ),
      ProgramUnitBlueprint(
        id: "visual-turns-and-repair",
        title: "Keep the exchange going",
        objectives: [
          "Recognize a turn opening and ending",
          "Use focused repair instead of pretending",
        ],
        vocabulary: ["turn", "pause", "repeat", "slower", "clarify", "confirm"],
        grammarFocus:
            "Gaze, pauses, and other contextual cues help organize turns. A request for repetition can target a specific segment of an utterance.",
        cultureFocus:
            "Repair is normal language use. Give and request feedback without shaming a learner.",
        receptiveTask:
            "Observe an approved exchange with a repair and identify what was misunderstood and how it was resolved.",
        expressiveTask:
            "Rehearse a pause, a learned clarification request, and a confirmation of the new information.",
        scenario:
            "Your partner gives a day and a location; you understand the day but miss the location.",
        partnerA: "You know Tuesday; ask only about the place.",
        partnerB:
            "You proposed the library entrance; repeat or rephrase that part when asked.",
        transferTwist:
            "Repetition does not help, so a rephrased explanation is needed.",
        conceptQuestion:
            "What should happen when repeating the same phrase still does not resolve a misunderstanding?",
        conceptAnswers: [
          "Try an appropriate rephrase or another focused clarification.",
          "Repeat faster to force the partner to adapt.",
          "Agree without understanding to avoid interrupting the flow.",
        ],
        rubric: [
          "Locates the misunderstanding",
          "Uses an appropriate repair strategy",
          "Confirms shared understanding",
        ],
        prerequisiteIds: ["preferences-and-negation"],
        referenceUrls: [
          "https://nad.org/knowledge-hub/american-sign-language/learning-american-sign-language/",
          "https://www.lifeprint.com/asl101/curriculum/curriculum.htm",
        ],
      ),
      ProgramUnitBlueprint(
        id: "a-visual-language",
        title: "A visual language",
        objectives: [
          "Integrate a first reciprocal introduction",
          "Explain why ASL includes grammar and culture",
        ],
        vocabulary: [
          "handshape",
          "movement",
          "location",
          "orientation",
          "nonmanuals",
          "community",
        ],
        grammarFocus:
            "ASL has its own grammatical system. The components of a sign and the organization of discourse cannot be replaced by a sequence of English labels.",
        cultureFocus:
            "Deaf identities and language histories are diverse; follow individuals’ chosen terms and communication preferences.",
        receptiveTask:
            "Follow two approved introductions by different signers and note both shared information and variation.",
        expressiveTask:
            "Complete a brief introduction, ask an unplanned question, and repair one misunderstanding with a partner.",
        scenario:
            "At the end of a beginner workshop, you meet a new participant without a script.",
        partnerA:
            "Find out the participant’s name and what they want to practice.",
        partnerB:
            "You are Lee and want to practice names; ask your partner about their goal.",
        transferTwist:
            "The partner uses a familiar concept with a variant you have not seen.",
        conceptQuestion:
            "A sign differs from your first classroom example. What follows?",
        conceptAnswers: [
          "Ask about its meaning and context before assuming it is incorrect.",
          "Every differing form must be an error because a language has one form per word.",
          "Any movement is equally valid in every context once you can guess the meaning.",
        ],
        rubric: [
          "Sustains a short reciprocal introduction",
          "Uses repair when a variant is unfamiliar",
          "Recognizes cultural and grammatical learning goals",
        ],
        prerequisiteIds: ["visual-turns-and-repair"],
        referenceUrls: [
          "https://www.nad.org/resources/american-sign-language/community-and-culture-frequently-asked-questions/",
          "https://nad.org/who-we-are/our-language/",
        ],
      ),
    ],
  ),
  ProgramBandBlueprint(
    id: "everyday-life",
    title: "Everyday life",
    subtitle: "Beginner",
    description:
        "Connect people, places, time, quantities, and familiar routines in increasingly useful everyday exchanges.",
    units: [
      ProgramUnitBlueprint(
        id: "people-and-places",
        title: "People and places",
        objectives: [
          "Introduce people important to you",
          "Maintain references across a short description",
        ],
        vocabulary: [
          "friend",
          "family",
          "household",
          "live",
          "place",
          "relationship",
        ],
        grammarFocus:
            "Introduce a referent before using a spatial reference again; maintain clear links between people and places.",
        cultureFocus:
            "Describe your actual relationships, including chosen family and varied household structures.",
        receptiveTask:
            "Map the people and places in an approved household introduction without assuming relationships that were not stated.",
        expressiveTask:
            "Introduce two people and describe where each lives using familiar structures.",
        scenario:
            "A community group is making a fictional neighborhood welcome map.",
        partnerA:
            "You know that Pat lives near the park and need to learn where Jo lives.",
        partnerB:
            "Jo lives near the library; ask which person lives near the park.",
        transferTwist:
            "The two people have the same first name and need another identifying detail.",
        conceptQuestion:
            "What should a viewer infer from a household description?",
        conceptAnswers: [
          "Only relationships and locations that are stated or clearly established.",
          "That everyone in the household has the same family relationship.",
          "That a repeated first name always refers to the same person.",
        ],
        rubric: [
          "Introduces people clearly",
          "Maintains person-place links",
          "Avoids unsupported assumptions",
        ],
        prerequisiteIds: ["a-visual-language"],
        referenceUrls: [
          "https://www.nad.org/resources/american-sign-language/community-and-culture-frequently-asked-questions/",
          "https://nad.org/who-we-are/our-language/",
        ],
      ),
      ProgramUnitBlueprint(
        id: "describing-people",
        title: "Describe with care",
        objectives: [
          "Select identifying details that serve a purpose",
          "Respect how a person describes themselves",
        ],
        vocabulary: [
          "appearance",
          "clothing",
          "height",
          "identify",
          "description",
          "context",
        ],
        grammarFocus:
            "Descriptions need an established referent and organized relevant details. Learn the contextual use of descriptive forms from fluent examples.",
        cultureFocus:
            "Physical descriptions should be respectful and relevant; do not infer identity or character from appearance.",
        receptiveTask:
            "Choose the intended person from an approved description, distinguishing stated features from assumed ones.",
        expressiveTask:
            "Describe a fictional person using two useful visible details without value judgments.",
        scenario:
            "A volunteer needs to find a colleague in a group wearing similar event shirts.",
        partnerA:
            "The colleague has a yellow scarf and a name badge; communicate useful details.",
        partnerB:
            "Two people wear yellow; ask which additional detail distinguishes the colleague.",
        transferTwist:
            "One identifying accessory is removed, so you need a different relevant detail.",
        conceptQuestion:
            "Two people share the first detail you gave. What should you add?",
        conceptAnswers: [
          "Another relevant identifying feature that you actually know.",
          "An assumed personality trait based on appearance.",
          "The same detail with more emphasis instead of clarifying.",
        ],
        rubric: [
          "Chooses relevant observable details",
          "Keeps the referent clear",
          "Responds respectfully when identification fails",
        ],
        prerequisiteIds: ["people-and-places"],
        referenceUrls: [
          "https://www.lifeprint.com/asl101/pages-layout/grammar.htm",
          "https://www.rit.edu/ntid/slpi",
        ],
      ),
      ProgramUnitBlueprint(
        id: "home-and-belongings",
        title: "Home and belongings",
        objectives: [
          "Describe a familiar room",
          "Distinguish location from ownership",
        ],
        vocabulary: ["room", "table", "chair", "door", "near", "belongings"],
        grammarFocus:
            "Spatial description benefits from a stable viewpoint and established landmarks; ownership and location communicate different relationships.",
        cultureFocus:
            "Do not assume one housing arrangement or standard of living when discussing home.",
        receptiveTask:
            "Reconstruct a simple room from an approved description and identify which details locate an object.",
        expressiveTask:
            "Describe a room with three landmarks and one belonging using modeled spatial language.",
        scenario: "A housemate asks where a borrowed notebook was left.",
        partnerA:
            "The notebook is on the table near the door, not on the owner’s desk.",
        partnerB:
            "You know the owner’s desk but need the notebook’s current location.",
        transferTwist:
            "The room contains two tables and one needs a distinguishing landmark.",
        conceptQuestion: "Knowing who owns an object tells you…",
        conceptAnswers: [
          "Its owner, but not necessarily its current location.",
          "Exactly where it must be in the room.",
          "That spatial landmarks are unnecessary for finding it.",
        ],
        rubric: [
          "Establishes room landmarks",
          "Separates ownership and location",
          "Clarifies an ambiguous object position",
        ],
        prerequisiteIds: ["describing-people"],
        referenceUrls: [
          "https://www.lifeprint.com/asl101/pages-layout/grammar.htm",
          "https://www.rit.edu/ntid/slpi",
        ],
      ),
      ProgramUnitBlueprint(
        id: "numbers-eleven-hundred",
        title: "Beyond counting on ten",
        objectives: [
          "Recognize two-digit quantities",
          "Distinguish number contexts",
        ],
        vocabulary: [
          "eleven to one hundred",
          "quantity",
          "address",
          "digits",
          "total",
          "correction",
        ],
        grammarFocus:
            "Two-digit numbers and digit strings have contextual conventions. Learn quantity, address, and identifier examples separately with approved models.",
        cultureFocus:
            "Allow repetition and confirmation when an incorrect number would change a practical outcome.",
        receptiveTask:
            "Identify educator-selected two-digit quantities and address digits from reviewed recordings with unfamiliar signers.",
        expressiveTask:
            "Exchange a fictional quantity and an address, explicitly establishing each number’s purpose.",
        scenario:
            "A group needs twenty-four chairs delivered to room forty-two.",
        partnerA:
            "You know the chair quantity and need to confirm the room identifier.",
        partnerB:
            "You know room 42 and need to confirm that the quantity is 24, not 42.",
        transferTwist: "The partner reverses the quantity and the room number.",
        conceptQuestion:
            "What prevents confusion between 24 chairs and room 42?",
        conceptAnswers: [
          "Clearly identify each number’s function and confirm any uncertain sequence.",
          "Assume context will correct every reversed digit automatically.",
          "Use the same unlabeled number twice and let the partner choose.",
        ],
        rubric: [
          "Recognizes the selected numbers",
          "Labels quantity and identifier",
          "Repairs a reversed-number misunderstanding",
        ],
        prerequisiteIds: ["home-and-belongings"],
        referenceUrls: [
          "https://www.lifeprint.com/asl101/pages-layout/grammar.htm",
          "https://www.rit.edu/ntid/slpi",
          "https://www.lifeprint.com/asl101/pages-layout/numericalincorporation.htm",
        ],
      ),
      ProgramUnitBlueprint(
        id: "ages-and-relationships",
        title: "People across generations",
        objectives: [
          "Discuss ages in learned contexts",
          "Connect people without assumptions",
        ],
        vocabulary: [
          "age",
          "older",
          "younger",
          "sibling",
          "generation",
          "relationship",
        ],
        grammarFocus:
            "Age expressions and number incorporation require contextual modeling; an isolated counting form is not a universal age construction.",
        cultureFocus:
            "Ages can be personal. Use fictional data and respect a person’s choice not to share.",
        receptiveTask:
            "Follow an approved introduction that distinguishes age, number of relatives, and relative age.",
        expressiveTask:
            "Describe a fictional relationship and compare ages using learned constructions.",
        scenario:
            "You are organizing an invented cast of characters for a story.",
        partnerA:
            "One character is 12 and has two siblings; convey which number means what.",
        partnerB:
            "You know there are two siblings and need the main character’s age.",
        transferTwist:
            "A partner confuses the number of siblings with the character’s age.",
        conceptQuestion: "Why learn ages in complete examples?",
        conceptAnswers: [
          "Age constructions use context and conventions beyond isolated counting.",
          "Every number in a personal introduction automatically expresses age.",
          "Counting forms can replace every age construction without adjustment.",
        ],
        rubric: [
          "Distinguishes age from quantity",
          "Uses a modeled age construction",
          "Handles fictional personal information respectfully",
        ],
        prerequisiteIds: ["numbers-eleven-hundred"],
        referenceUrls: [
          "https://www.lifeprint.com/asl101/pages-layout/grammar.htm",
          "https://www.rit.edu/ntid/slpi",
          "https://www.lifeprint.com/asl101/pages-layout/numericalincorporation.htm",
        ],
      ),
      ProgramUnitBlueprint(
        id: "everyday-rhythms",
        title: "Everyday rhythms",
        objectives: [
          "Describe a familiar routine in order",
          "Mark a change in time frame",
        ],
        vocabulary: [
          "morning",
          "evening",
          "work",
          "study",
          "routine",
          "time frame",
        ],
        grammarFocus:
            "A time frame can organize connected events; a change from a routine to a different day must be made clear.",
        cultureFocus:
            "Do not treat a single work, school, or sleep schedule as universal.",
        receptiveTask:
            "Order familiar activities after an approved routine description and identify an explicitly changed time frame.",
        expressiveTask:
            "Describe three activities in a routine, then explain one exception using learned temporal language.",
        scenario:
            "You and a partner compare when you can practice around your routines.",
        partnerA:
            "You usually study in the evening but are free this Thursday evening.",
        partnerB:
            "You are free Thursday evening and need to know whether this is a regular time.",
        transferTwist:
            "A partner treats the one-time exception as your weekly availability.",
        conceptQuestion:
            "What needs to be clear when a routine has a one-time exception?",
        conceptAnswers: [
          "Which details are habitual and which apply only to the specified occasion.",
          "That every routine statement applies without exception.",
          "That repeating an activity sign alone identifies every time frame.",
        ],
        rubric: [
          "Organizes a routine coherently",
          "Marks the exceptional time",
          "Corrects an overgeneralized schedule",
        ],
        prerequisiteIds: ["ages-and-relationships"],
        referenceUrls: [
          "https://www.lifeprint.com/asl101/pages-layout/grammar.htm",
          "https://www.rit.edu/ntid/slpi",
        ],
      ),
      ProgramUnitBlueprint(
        id: "calendar-and-clock",
        title: "Dates, days, and time",
        objectives: [
          "Exchange a day and time accurately",
          "Clarify an incomplete appointment",
        ],
        vocabulary: [
          "day",
          "date",
          "clock time",
          "week",
          "morning",
          "afternoon",
        ],
        grammarFocus:
            "Days, dates, and clock times are distinct temporal expressions with their own forms and conventions. A date alone may not specify a meeting time.",
        cultureFocus:
            "Confirm time zones and access arrangements when people meet remotely.",
        receptiveTask:
            "Extract day, date, and time separately from reviewed scheduling exchanges.",
        expressiveTask:
            "Arrange a fictional meeting and repeat back the complete agreed details.",
        scenario:
            "A partner proposes next Tuesday afternoon, but the exact time is missing.",
        partnerA:
            "You can meet at either 2 or 3; find out which time is intended.",
        partnerB:
            "You intended 3 in your local time zone; confirm the zone if needed.",
        transferTwist:
            "You discover that the two people are in different time zones.",
        conceptQuestion: "What remains uncertain in “next Tuesday afternoon”?",
        conceptAnswers: [
          "The exact time and, when relevant, the time zone.",
          "Nothing; afternoon always identifies one precise meeting time.",
          "Only the weekday, even though Tuesday was clearly stated.",
        ],
        rubric: [
          "Separates day date and time",
          "Clarifies the missing temporal detail",
          "Confirms a shared meeting time",
        ],
        prerequisiteIds: ["everyday-rhythms"],
        referenceUrls: [
          "https://www.lifeprint.com/asl101/pages-layout/grammar.htm",
          "https://www.rit.edu/ntid/slpi",
          "https://www.lifeprint.com/asl101/pages-layout/numericalincorporation.htm",
        ],
      ),
      ProgramUnitBlueprint(
        id: "food-and-choices",
        title: "Food and choices",
        objectives: [
          "Request a familiar item",
          "Clarify an available alternative",
        ],
        vocabulary: [
          "food",
          "drink",
          "choice",
          "ingredient",
          "available",
          "preference",
        ],
        grammarFocus:
            "Requests, preference statements, and clarification questions have different functions even when they share food vocabulary.",
        cultureFocus:
            "Respect dietary choices; ingredient questions are practical requests rather than invitations to judge.",
        receptiveTask:
            "Identify an order and an offered substitution in a reviewed café exchange.",
        expressiveTask:
            "Request a familiar item, ask about one alternative, and confirm the choice with learned language.",
        scenario:
            "A café has tea and water, but the drink you first requested is unavailable.",
        partnerA:
            "You prefer water if the first choice is unavailable; communicate the final choice.",
        partnerB:
            "You can provide tea or water; ask which alternative is wanted.",
        transferTwist:
            "The partner hears the original item but misses that your choice changed.",
        conceptQuestion: "What makes a substitution exchange complete?",
        conceptAnswers: [
          "Both people understand the final choice after the alternatives were clarified.",
          "Only the first request matters, even after it becomes unavailable.",
          "Listing possible items is the same as agreeing on one.",
        ],
        rubric: [
          "Expresses a contextual request",
          "Clarifies an alternative",
          "Confirms the selected item",
        ],
        prerequisiteIds: ["calendar-and-clock"],
        referenceUrls: [
          "https://www.lifeprint.com/asl101/pages-layout/grammar.htm",
          "https://www.rit.edu/ntid/slpi",
        ],
      ),
      ProgramUnitBlueprint(
        id: "shopping-and-money",
        title: "Shopping with clarity",
        objectives: [
          "Distinguish price and quantity",
          "Confirm a purchase detail using fictional data",
        ],
        vocabulary: [
          "price",
          "amount",
          "quantity",
          "total",
          "change",
          "receipt",
        ],
        grammarFocus:
            "Money expressions must be learned in their currency and transaction context; a bare number can be ambiguous between price and quantity.",
        cultureFocus:
            "Practice with fictional purchases and never enter private payment information into a language exercise.",
        receptiveTask:
            "Separate quantity, item price, and total in an approved simple transaction.",
        expressiveTask:
            "Ask about a fictional price and clarify whether it refers to one item or the whole group.",
        scenario:
            "A stall labels a set of cards “6,” but you do not know whether that is a price or a count.",
        partnerA: "You want three cards and need the per-item price.",
        partnerB:
            "The sign means six cards in a pack; the fictional pack price is different.",
        transferTwist:
            "The seller changes from a per-item price to a bundle price.",
        conceptQuestion:
            "What should you establish before interpreting a number in a transaction?",
        conceptAnswers: [
          "Whether it expresses quantity, per-item price, or a total.",
          "That the largest number must always be the total price.",
          "That currency and quantity use interchangeable meaning in context.",
        ],
        rubric: [
          "Labels each numerical function",
          "Asks a focused price question",
          "Confirms the agreed quantity and total",
        ],
        prerequisiteIds: ["food-and-choices"],
        referenceUrls: [
          "https://www.lifeprint.com/asl101/pages-layout/grammar.htm",
          "https://www.rit.edu/ntid/slpi",
          "https://www.lifeprint.com/asl101/pages-layout/numericalincorporation.htm",
        ],
      ),
      ProgramUnitBlueprint(
        id: "school-and-work",
        title: "School and work",
        objectives: [
          "Describe a role and a place",
          "Ask about a familiar daily responsibility",
        ],
        vocabulary: [
          "student",
          "teacher",
          "work",
          "study",
          "role",
          "responsibility",
        ],
        grammarFocus:
            "A person’s role, workplace, and current action are distinct information. Use learned structures to connect the right action to the right person.",
        cultureFocus:
            "Avoid assumptions about education, employment, or capability based on hearing status.",
        receptiveTask:
            "Identify who works or studies where and what they do in reviewed introductions.",
        expressiveTask:
            "Give a brief fictional role introduction and ask a relevant follow-up about responsibilities.",
        scenario:
            "A new club member says they work at a school but has not named their role.",
        partnerA: "You know the workplace; ask what kind of work they do.",
        partnerB:
            "You organize the library collection and are not a classroom teacher.",
        transferTwist:
            "The partner assumes everyone working at the school teaches classes.",
        conceptQuestion:
            "A person says they work at a school. What can you conclude?",
        conceptAnswers: [
          "Their workplace is a school; their specific role still needs clarification.",
          "They necessarily teach a classroom.",
          "Their role can be inferred from their hearing status.",
        ],
        rubric: [
          "Separates role workplace and action",
          "Asks a relevant follow-up",
          "Corrects an unsupported assumption",
        ],
        prerequisiteIds: ["shopping-and-money"],
        referenceUrls: [
          "https://www.nad.org/resources/american-sign-language/community-and-culture-frequently-asked-questions/",
          "https://nad.org/who-we-are/our-language/",
        ],
      ),
      ProgramUnitBlueprint(
        id: "weather-and-seasons",
        title: "Weather and changing plans",
        objectives: [
          "Describe familiar weather in context",
          "Connect conditions to an activity choice",
        ],
        vocabulary: [
          "weather",
          "season",
          "rain",
          "sun",
          "hot",
          "cold",
          "activity",
        ],
        grammarFocus:
            "A present observation, a typical seasonal pattern, and a prediction have different time and certainty frames.",
        cultureFocus:
            "Weather and seasonal experiences vary by location; invite the partner’s actual experience.",
        receptiveTask:
            "Distinguish current conditions from a future forecast in approved familiar-language examples.",
        expressiveTask:
            "Describe current fictional conditions and suggest a related activity using learned forms.",
        scenario:
            "A group planned a park visit, but rain is possible tomorrow afternoon.",
        partnerA:
            "You know the forecast is uncertain; propose an indoor backup.",
        partnerB:
            "You can reserve a room today but need to know whether it replaces or backs up the park.",
        transferTwist: "The forecast changes and the park remains usable.",
        conceptQuestion:
            "A forecast says rain is possible. How should you describe the plan?",
        conceptAnswers: [
          "Distinguish the uncertain forecast from a confirmed change of plan.",
          "State that rain has already happened because it was predicted.",
          "Treat a backup option as a confirmed cancellation without agreement.",
        ],
        rubric: [
          "Distinguishes observation and prediction",
          "Connects conditions to a relevant option",
          "Confirms whether a plan actually changed",
        ],
        prerequisiteIds: ["school-and-work"],
        referenceUrls: [
          "https://www.lifeprint.com/asl101/pages-layout/grammar.htm",
          "https://www.rit.edu/ntid/slpi",
        ],
      ),
      ProgramUnitBlueprint(
        id: "neighborhood-cafe",
        title: "The neighborhood café",
        objectives: [
          "Integrate a familiar service exchange",
          "Locate a partner and close the conversation",
        ],
        vocabulary: [
          "order",
          "table",
          "window",
          "preference",
          "repeat",
          "meet",
        ],
        grammarFocus:
            "Combine requests, stable spatial references, time, and repair without losing who or what each reference identifies.",
        cultureFocus:
            "Visual access and respectful turn-taking matter in shared public spaces.",
        receptiveTask:
            "Follow a reviewed café encounter with an order change and a reference to a meeting place.",
        expressiveTask:
            "Request an item, clarify a change, describe a table, and close a brief interaction.",
        scenario:
            "You order at the café before meeting a friend at a table near the window.",
        partnerA:
            "You chose water and need to tell the friend where you are sitting.",
        partnerB:
            "You see two window tables and need one more identifying detail.",
        transferTwist: "The window table fills up and you move near the door.",
        conceptQuestion: "When you change tables, what does your friend need?",
        conceptAnswers: [
          "A clear update that replaces the old location with the new one.",
          "Both locations listed without indicating which is current.",
          "Only a repeat of the original table description.",
        ],
        rubric: [
          "Completes the service request",
          "Maintains and updates spatial references",
          "Uses a focused repair and clear closing",
        ],
        prerequisiteIds: ["weather-and-seasons"],
        referenceUrls: [
          "https://www.lifeprint.com/asl101/pages-layout/grammar.htm",
          "https://www.rit.edu/ntid/slpi",
        ],
      ),
    ],
  ),
  ProgramBandBlueprint(
    id: "connecting-ideas",
    title: "Connecting ideas",
    subtitle: "Developing",
    description:
        "Move from familiar exchanges into connected ideas, spatial descriptions, negotiated plans, and practical problem solving.",
    units: [
      ProgramUnitBlueprint(
        id: "making-plans",
        title: "Making plans",
        objectives: [
          "Negotiate an activity and a time",
          "Confirm a complete shared plan",
        ],
        vocabulary: ["invite", "available", "busy", "plan", "place", "confirm"],
        grammarFocus:
            "An invitation, an availability question, and a confirmation each do different work in discourse.",
        cultureFocus:
            "Leave room for someone to decline or propose a different arrangement.",
        receptiveTask:
            "Follow a reviewed planning exchange and separate suggestions from the final agreement.",
        expressiveTask:
            "Invite a partner, respond to an alternative, and confirm activity, time, and place.",
        scenario:
            "You want to visit an exhibit with a friend whose schedule you do not know.",
        partnerA:
            "You are free Saturday morning or Sunday afternoon; find an overlap.",
        partnerB:
            "You are busy Saturday and free Sunday afternoon; clarify the exhibit location.",
        transferTwist:
            "The exhibit closes earlier on Sunday than either person expected.",
        conceptQuestion: "What distinguishes a suggestion from an agreed plan?",
        conceptAnswers: [
          "The participants have responded and confirmed the relevant shared details.",
          "The first person to name a time has settled the plan.",
          "Any mention of an alternative automatically cancels the original invitation.",
        ],
        rubric: [
          "Distinguishes proposed and agreed details",
          "Responds to availability",
          "Confirms the final arrangement",
        ],
        prerequisiteIds: ["neighborhood-cafe"],
        referenceUrls: [
          "https://www.lifeprint.com/asl101/pages-layout/grammar.htm",
          "https://www.rit.edu/ntid/slpi",
        ],
      ),
      ProgramUnitBlueprint(
        id: "invitations-and-boundaries",
        title: "Invitations and boundaries",
        objectives: [
          "Accept or decline clearly",
          "Negotiate without pressuring a partner",
        ],
        vocabulary: [
          "accept",
          "decline",
          "perhaps",
          "available",
          "prefer",
          "alternative",
        ],
        grammarFocus:
            "A refusal, uncertainty, and a counterproposal differ in meaning. Clarify the scope of a response rather than inferring a permanent preference.",
        cultureFocus:
            "Respect boundaries and avoid demanding personal explanations for a refusal.",
        receptiveTask:
            "Identify whether reviewed responses accept, decline, defer, or offer an alternative.",
        expressiveTask:
            "Practice a clear response to an invitation and a relevant optional counterproposal.",
        scenario:
            "A friend invites you to a crowded evening event; you prefer a quieter meeting another day.",
        partnerA:
            "Decline this event and offer a quiet afternoon meeting if you wish.",
        partnerB:
            "You can meet another afternoon; clarify whether the invitation is declined or postponed.",
        transferTwist:
            "The partner assumes declining one event means ending the friendship.",
        conceptQuestion:
            "What does declining a particular invitation establish?",
        conceptAnswers: [
          "That this invitation is declined; broader conclusions require more information.",
          "That the person never wants to meet again.",
          "That they must provide a detailed personal reason before the refusal counts.",
        ],
        rubric: [
          "Makes acceptance uncertainty or refusal clear",
          "Respects the partner’s boundary",
          "Keeps an alternative distinct from the original plan",
        ],
        prerequisiteIds: ["making-plans"],
        referenceUrls: [
          "https://www.nad.org/resources/american-sign-language/community-and-culture-frequently-asked-questions/",
          "https://nad.org/who-we-are/our-language/",
        ],
      ),
      ProgramUnitBlueprint(
        id: "reasons-and-alternatives",
        title: "Reasons and alternatives",
        objectives: [
          "Connect a change to a relevant reason",
          "Compare two feasible alternatives",
        ],
        vocabulary: [
          "because",
          "reason",
          "change",
          "instead",
          "option",
          "consequence",
        ],
        grammarFocus:
            "Reason, event, and consequence should remain distinguishable. Learn contextual linking structures rather than translating every English connective directly.",
        cultureFocus:
            "A concise reason can be sufficient; learners should not invent personal details to sound fluent.",
        receptiveTask:
            "Identify what changed, why it changed, and which alternative was accepted in reviewed signed exchanges.",
        expressiveTask:
            "Explain one practical change, offer two alternatives, and ask for a preference.",
        scenario:
            "A room is unavailable, so a club must choose the courtyard or another classroom.",
        partnerA:
            "The original room is closed; the courtyard is free but exposed to weather.",
        partnerB:
            "Another classroom is available after 4; explain this constraint when asked.",
        transferTwist: "One option has poor sightlines for the group.",
        conceptQuestion: "What helps a partner evaluate an alternative?",
        conceptAnswers: [
          "The relevant constraints and consequences, clearly linked to that option.",
          "A longer list of unrelated reasons with no option identified.",
          "Presenting every possible consequence as an established fact.",
        ],
        rubric: [
          "Links a change to its reason",
          "Keeps alternatives distinct",
          "Uses relevant constraints to reach an agreement",
        ],
        prerequisiteIds: ["invitations-and-boundaries"],
        referenceUrls: [
          "https://www.lifeprint.com/asl101/pages-layout/grammar.htm",
          "https://www.rit.edu/ntid/slpi",
        ],
      ),
      ProgramUnitBlueprint(
        id: "describing-your-world",
        title: "Describing your world",
        objectives: [
          "Establish a spatial frame",
          "Keep viewpoint consistent while adding detail",
        ],
        vocabulary: [
          "layout",
          "landmark",
          "location",
          "perspective",
          "near",
          "across",
        ],
        grammarFocus:
            "Spatial descriptions require an established viewpoint and consistent referents; actual grammar must be learned from whole-signer demonstrations.",
        cultureFocus:
            "Descriptions should fit the listener’s information needs rather than assume they know the place.",
        receptiveTask:
            "Build a simple map from a reviewed signed description and identify the viewpoint it uses.",
        expressiveTask:
            "Describe a familiar layout using three landmarks and answer one clarification.",
        scenario:
            "A visitor needs to locate a display inside an unfamiliar community center.",
        partnerA:
            "You know the entrance, desk, and display positions; establish a starting viewpoint.",
        partnerB:
            "You have a map with two possible display locations; ask for a distinguishing relationship.",
        transferTwist: "The visitor enters from the opposite door.",
        conceptQuestion:
            "Why establish a viewpoint before describing locations?",
        conceptAnswers: [
          "The viewer needs a stable frame for interpreting spatial relationships.",
          "A viewpoint can be changed after each detail without affecting meaning.",
          "Using English left and right labels alone teaches the complete ASL construction.",
        ],
        rubric: [
          "Establishes a usable viewpoint",
          "Maintains stable landmark relationships",
          "Explains an intentional perspective change",
        ],
        prerequisiteIds: ["reasons-and-alternatives"],
        referenceUrls: [
          "https://www.lifeprint.com/asl101/pages-layout/grammar.htm",
          "https://www.rit.edu/ntid/slpi",
        ],
      ),
      ProgramUnitBlueprint(
        id: "depicting-entities",
        title: "Entities in space",
        objectives: [
          "Identify the referent of a depicting construction",
          "Represent a learned path consistently",
        ],
        vocabulary: [
          "entity",
          "referent",
          "path",
          "location",
          "depicting construction",
          "movement",
        ],
        grammarFocus:
            "Depicting handshapes are linguistically constrained and context dependent. Introduce the entity and learn the appropriate construction from fluent models.",
        cultureFocus:
            "Avoid treating ASL as universal pantomime or assuming any visually suggestive movement is grammatical.",
        receptiveTask:
            "In reviewed examples, identify the entity, starting location, path, and endpoint without relying on English labels.",
        expressiveTask:
            "Use a taught construction to depict one entity moving relative to a stationary landmark.",
        scenario:
            "A character crosses a courtyard and passes a stationary bicycle before reaching a door.",
        partnerA:
            "You know the character’s path; communicate which side of the bicycle they passed.",
        partnerB:
            "You know two possible routes and must identify the correct one from the description.",
        transferTwist:
            "Another moving entity enters the scene and must be distinguished.",
        conceptQuestion: "What should determine a depicting handshape?",
        conceptAnswers: [
          "The learned ASL construction, referent, and context.",
          "The first English letter of any object being represented.",
          "Any shape that looks similar to the object regardless of linguistic convention.",
        ],
        rubric: [
          "Establishes the intended entity",
          "Uses an educator-modeled construction",
          "Maintains a coherent path and endpoint",
        ],
        prerequisiteIds: ["describing-your-world"],
        referenceUrls: [
          "https://www.lifeprint.com/asl101/pages-layout/grammar.htm",
          "https://www.rit.edu/ntid/slpi",
        ],
      ),
      ProgramUnitBlueprint(
        id: "handling-and-objects",
        title: "Handling and object description",
        objectives: [
          "Distinguish handling from entity depiction",
          "Describe object use with learned forms",
        ],
        vocabulary: ["handle", "use", "object", "shape", "size", "action"],
        grammarFocus:
            "A construction showing an entity and one showing a person handling an object serve different functions; choice depends on the intended meaning.",
        cultureFocus:
            "Different bodies and tools affect how an action is carried out; do not equate one physical performance with everyone’s experience.",
        receptiveTask:
            "Compare reviewed examples showing an object’s position with examples showing its use.",
        expressiveTask:
            "Describe a familiar object and a taught handling action, keeping the actor and object identifiable.",
        scenario:
            "You explain how a fictional character moved a box and then placed it on a shelf.",
        partnerA:
            "You know the box was carried with two hands; distinguish handling from its final location.",
        partnerB:
            "You need to know how it was moved and which shelf now holds it.",
        transferTwist:
            "A handle changes how the character carries the same object.",
        conceptQuestion: "Why distinguish entity depiction from handling?",
        conceptAnswers: [
          "They represent different aspects of the event and may require different learned constructions.",
          "They are interchangeable whenever the English object name stays the same.",
          "Handling always replaces the need to identify who acts.",
        ],
        rubric: [
          "Distinguishes object and actor",
          "Selects a taught construction for the meaning",
          "Maintains the object’s final location",
        ],
        prerequisiteIds: ["depicting-entities"],
        referenceUrls: [
          "https://www.lifeprint.com/asl101/pages-layout/grammar.htm",
          "https://www.rit.edu/ntid/slpi",
        ],
      ),
      ProgramUnitBlueprint(
        id: "agreement-and-referents",
        title: "Who did what to whom",
        objectives: [
          "Track participants in an action",
          "Use agreement patterns only where learned",
        ],
        vocabulary: [
          "give",
          "tell",
          "ask",
          "person",
          "agreement",
          "directionality",
        ],
        grammarFocus:
            "Some verbs permit spatial agreement, but not every verb follows the same pattern. Established referents and verb-specific behavior matter.",
        cultureFocus:
            "Do not treat all interpersonal actions as literal transfers or assume English pronouns map one-to-one onto forms.",
        receptiveTask:
            "Identify actor and recipient in reviewed examples where referents and directionality are informative.",
        expressiveTask:
            "Introduce two people and rehearse a taught action between them, then reverse the roles clearly.",
        scenario:
            "A workshop organizer gives a folder to a volunteer, who later returns it.",
        partnerA: "You know who first held the folder and who received it.",
        partnerB:
            "You need to determine who has the folder after it is returned.",
        transferTwist:
            "A third person joins, requiring another established referent.",
        conceptQuestion:
            "Can a learner apply one directional pattern to every ASL verb?",
        conceptAnswers: [
          "No; agreement behavior depends on the verb and its learned construction.",
          "Yes; every verb is made grammatical by moving it toward any referent.",
          "Yes; direction alone removes the need to establish participants.",
        ],
        rubric: [
          "Establishes actor and recipient",
          "Uses the taught verb pattern",
          "Keeps roles clear when the action reverses",
        ],
        prerequisiteIds: ["handling-and-objects"],
        referenceUrls: [
          "https://www.lifeprint.com/asl101/pages-layout/grammar.htm",
          "https://www.rit.edu/ntid/slpi",
        ],
      ),
      ProgramUnitBlueprint(
        id: "repetition-and-duration",
        title: "How often, how long",
        objectives: [
          "Distinguish repeated and sustained events",
          "Notice meaningful movement modification",
        ],
        vocabulary: [
          "repeat",
          "often",
          "continue",
          "duration",
          "frequency",
          "event",
        ],
        grammarFocus:
            "Aspectual meanings involve learned patterns and context. Repeating a movement arbitrarily is not a universal way to express every kind of repetition or duration.",
        cultureFocus:
            "Discuss routines without judging different work rhythms or access-related needs.",
        receptiveTask:
            "Compare approved utterances for a single event, a recurring event, and a sustained event.",
        expressiveTask:
            "Describe one taught activity in two time patterns and make the intended contrast clear.",
        scenario:
            "Two volunteers water plants: one does it once today; the other does it every morning.",
        partnerA:
            "You handle today’s one-time watering; clarify the regular schedule.",
        partnerB:
            "You handle the recurring morning watering; ask whether today’s task is already done.",
        transferTwist:
            "A continuous task is mistaken for several separate repetitions.",
        conceptQuestion:
            "What must a learner know before modifying movement for aspect?",
        conceptAnswers: [
          "Which learned construction expresses the intended frequency or duration in context.",
          "That faster repetition always means a longer continuous event.",
          "That all signs accept the same movement modification with the same meaning.",
        ],
        rubric: [
          "Distinguishes event frequency and duration",
          "Uses a taught aspectual pattern",
          "Repairs an incorrect temporal interpretation",
        ],
        prerequisiteIds: ["agreement-and-referents"],
        referenceUrls: [
          "https://www.lifeprint.com/asl101/pages-layout/grammar.htm",
          "https://www.rit.edu/ntid/slpi",
        ],
      ),
      ProgramUnitBlueprint(
        id: "travel-and-transport",
        title: "Getting across town",
        objectives: [
          "Explain a short route with landmarks",
          "Clarify a changed connection",
        ],
        vocabulary: [
          "bus",
          "train",
          "walk",
          "transfer",
          "destination",
          "landmark",
        ],
        grammarFocus:
            "Route discourse links a shared starting point, ordered segments, and a destination; perspective shifts need to be explicit.",
        cultureFocus:
            "Ask about actual travel and access needs rather than assuming everyone walks or drives.",
        receptiveTask:
            "Follow a reviewed short route and select the map whose landmarks and order match.",
        expressiveTask:
            "Explain two route segments and a transfer using modeled spatial language.",
        scenario:
            "A visitor needs to reach an exhibit using a bus and a short final route.",
        partnerA:
            "You know where to board and transfer; ask about the last segment.",
        partnerB:
            "You know the last landmark and entrance; ask where the visitor starts.",
        transferTwist:
            "The usual entrance is closed and an accessible alternate entrance is in use.",
        conceptQuestion: "What should a changed route update include?",
        conceptAnswers: [
          "The affected segment and a clear replacement connected to the shared route.",
          "Only the destination, even if the previous entrance is closed.",
          "A new perspective without explaining how it relates to the old route.",
        ],
        rubric: [
          "Establishes a starting point",
          "Sequences the route coherently",
          "Clarifies a changed segment and access needs",
        ],
        prerequisiteIds: ["repetition-and-duration"],
        referenceUrls: [
          "https://www.lifeprint.com/asl101/pages-layout/grammar.htm",
          "https://www.rit.edu/ntid/slpi",
        ],
      ),
      ProgramUnitBlueprint(
        id: "services-and-appointments",
        title: "A useful service exchange",
        objectives: [
          "State a practical need",
          "Confirm an appointment and communication preference",
        ],
        vocabulary: [
          "appointment",
          "service",
          "schedule",
          "request",
          "access",
          "confirm",
        ],
        grammarFocus:
            "Separate the service request, scheduling details, and clarification. A confirmation should identify which proposition has been agreed.",
        cultureFocus:
            "Communication access is based on the person’s preferences and context, not assumptions about hearing status.",
        receptiveTask:
            "Extract a requested service, proposed time, and unresolved question from an approved fictional exchange.",
        expressiveTask:
            "Request an ordinary service and confirm a fictional appointment without sharing private information.",
        scenario:
            "You arrange a library equipment demonstration and need a clear view of the presenter.",
        partnerA:
            "You are available Friday afternoon and want to ask about the setup.",
        partnerB:
            "You can offer 2 or 4 and need the learner’s communication preference.",
        transferTwist:
            "The appointment remains at the same time but moves to another room.",
        conceptQuestion:
            "What should be checked separately in an appointment exchange?",
        conceptAnswers: [
          "The agreed service, scheduling details, and relevant access arrangements.",
          "Only the clock time because all other details follow automatically.",
          "A presumed communication preference based on a label.",
        ],
        rubric: [
          "States a focused service need",
          "Confirms time place and purpose",
          "Asks about access without assuming",
        ],
        prerequisiteIds: ["travel-and-transport"],
        referenceUrls: [
          "https://www.nad.org/resources/american-sign-language/community-and-culture-frequently-asked-questions/",
          "https://nad.org/who-we-are/our-language/",
        ],
      ),
      ProgramUnitBlueprint(
        id: "getting-things-done",
        title: "Getting things done",
        objectives: [
          "Combine incomplete information",
          "Resolve a practical problem collaboratively",
        ],
        vocabulary: [
          "problem",
          "detail",
          "missing",
          "solution",
          "clarify",
          "confirm",
        ],
        grammarFocus:
            "Problem-solving discourse separates known facts, uncertainty, proposals, and agreement. Referents must remain stable as information is added.",
        cultureFocus:
            "A fluent-looking guess is less useful than honest clarification when others rely on the information.",
        receptiveTask:
            "Follow an approved problem-solving exchange and identify the missing fact that drives the repair.",
        expressiveTask:
            "State a problem, ask a focused question, and confirm the next action with a partner.",
        scenario:
            "A workshop room changes; one participant knows the new floor, another knows the room number.",
        partnerA:
            "You know the new room is on the second floor but lack the number.",
        partnerB: "You know the number is 204 but need to confirm the floor.",
        transferTwist:
            "A notice contains an older room assignment that conflicts with the update.",
        conceptQuestion: "How should conflicting room information be handled?",
        conceptAnswers: [
          "Identify which information is current and confirm the destination before acting.",
          "Follow the first number mentioned without checking its source.",
          "Combine details from incompatible notices as if they were one confirmed plan.",
        ],
        rubric: [
          "Separates known and missing facts",
          "Uses focused clarification",
          "Confirms one coherent next action",
        ],
        prerequisiteIds: ["services-and-appointments"],
        referenceUrls: [
          "https://www.lifeprint.com/asl101/pages-layout/grammar.htm",
          "https://www.rit.edu/ntid/slpi",
        ],
      ),
      ProgramUnitBlueprint(
        id: "plans-in-practice",
        title: "Plans in practice",
        objectives: [
          "Integrate description and negotiation",
          "Adapt a plan after an unexpected response",
        ],
        vocabulary: [
          "plan",
          "schedule",
          "route",
          "alternative",
          "reason",
          "agreement",
        ],
        grammarFocus:
            "Connected discourse combines temporal frames, reference, questions, and repair; successful planning depends on the partner’s response.",
        cultureFocus:
            "A solo script prepares language but does not demonstrate spontaneous interaction.",
        receptiveTask:
            "Follow an unseen approved planning exchange and summarize only the agreed details.",
        expressiveTask:
            "Negotiate an outing with an actual consenting partner who contributes an unplanned constraint.",
        scenario:
            "You plan a fictional museum outing including time, transport, and a meeting point.",
        partnerA:
            "You can arrive after 1 and prefer the main entrance; discover your partner’s constraint.",
        partnerB:
            "You need an accessible side entrance and can arrive at 2; negotiate a shared plan.",
        transferTwist:
            "One transit connection is canceled while you are confirming the plan.",
        conceptQuestion:
            "What offers evidence beyond memorizing a planning script?",
        conceptAnswers: [
          "Responding meaningfully to new partner information and reaching a shared agreement.",
          "Repeating the same script faster each time.",
          "Checking off all planning vocabulary without receiving a partner response.",
        ],
        rubric: [
          "Integrates time place and route",
          "Adapts after unplanned information",
          "Confirms a feasible shared plan",
        ],
        prerequisiteIds: ["getting-things-done"],
        referenceUrls: [
          "https://gallaudet.edu/american-sign-language-proficiency-interview-aslpi/aslpi-preparation/aslpi-proficiency-levels/",
          "https://www.rit.edu/ntid/slpi",
        ],
      ),
    ],
  ),
  ProgramBandBlueprint(
    id: "stories-in-motion",
    title: "Stories in motion",
    subtitle: "Intermediate",
    description:
        "Develop coherent narratives with sequence, referents, viewpoint, constructed action, and audience-aware revision.",
    units: [
      ProgramUnitBlueprint(
        id: "a-story-worth-sharing",
        title: "A story worth sharing",
        objectives: [
          "Establish a relevant setting",
          "Organize a beginning event and ending",
        ],
        vocabulary: [
          "setting",
          "character",
          "event",
          "sequence",
          "ending",
          "narrator",
        ],
        grammarFocus:
            "Narratives establish people, place, and time before developing events; details need clear relationships to the discourse.",
        cultureFocus:
            "Tell your own experiences or appropriately attributed fictional stories rather than claiming another person’s story.",
        receptiveTask:
            "Identify the setting, central event, and resolution of an approved short signed narrative.",
        expressiveTask:
            "Tell a low-stakes personal or fictional event in three coherent beats.",
        scenario:
            "You arrived early for a picnic, discovered the wrong park, and found the group after a clarification.",
        partnerA:
            "You know your own mistaken assumption and the route you took.",
        partnerB:
            "You know where the group actually met and why its message was ambiguous.",
        transferTwist:
            "The audience does not know that the town has two parks with similar names.",
        conceptQuestion: "Which detail should the story opening establish?",
        conceptAnswers: [
          "The context needed to understand the central event, including the similar park names.",
          "Every unrelated detail from the narrator’s week.",
          "Only the ending, with no way to identify people or places.",
        ],
        rubric: [
          "Establishes necessary context",
          "Maintains a coherent event sequence",
          "Connects the ending to the event",
        ],
        prerequisiteIds: ["plans-in-practice"],
        referenceUrls: [
          "https://www.lifeprint.com/asl101/pages-layout/grammar.htm",
          "https://www.rit.edu/ntid/slpi",
        ],
      ),
      ProgramUnitBlueprint(
        id: "sequence-and-time-shifts",
        title: "Then, before, and meanwhile",
        objectives: [
          "Track event order separately from telling order",
          "Make a time shift understandable",
        ],
        vocabulary: [
          "before",
          "after",
          "earlier",
          "meanwhile",
          "time frame",
          "sequence",
        ],
        grammarFocus:
            "Narration may depart from chronological order, but the viewer needs clear temporal transitions and a stable return point.",
        cultureFocus:
            "Do not assume a viewer shares your background knowledge of an event’s timing.",
        receptiveTask:
            "Reconstruct event order from a reviewed narrative that briefly returns to an earlier moment.",
        expressiveTask:
            "Tell a short event chronologically, then add one clearly marked earlier detail.",
        scenario:
            "A character realizes at the station that the ticket was left at home before breakfast.",
        partnerA:
            "You narrate the station discovery and need the earlier home detail.",
        partnerB:
            "You know where the ticket was left and when; explain it without changing the station event.",
        transferTwist:
            "A second event happens simultaneously and needs its own temporal relationship.",
        conceptQuestion:
            "What must remain clear when narration jumps backward in time?",
        conceptAnswers: [
          "The relationship between the earlier event and the current narrative frame.",
          "That the event most recently told must have happened last.",
          "That a time shift automatically changes every established character.",
        ],
        rubric: [
          "Distinguishes telling order and event order",
          "Marks a deliberate time shift",
          "Returns to the main narrative frame",
        ],
        prerequisiteIds: ["a-story-worth-sharing"],
        referenceUrls: [
          "https://www.lifeprint.com/asl101/pages-layout/grammar.htm",
          "https://www.rit.edu/ntid/slpi",
        ],
      ),
      ProgramUnitBlueprint(
        id: "setting-and-perspective",
        title: "A scene the audience can enter",
        objectives: [
          "Establish a viewpoint for a setting",
          "Move between locations without losing orientation",
        ],
        vocabulary: [
          "viewpoint",
          "scene",
          "background",
          "foreground",
          "location",
          "transition",
        ],
        grammarFocus:
            "Spatial narrative builds a model the viewer can maintain. An intentional viewpoint change needs contextual marking, not unexplained remapping.",
        cultureFocus:
            "A detailed description should serve the audience rather than equate visual complexity with skill.",
        receptiveTask:
            "Map a setting and identify an intentional viewpoint change in reviewed narration.",
        expressiveTask:
            "Establish two landmarks, place a character, and explain a change of viewpoint with taught forms.",
        scenario:
            "A character watches a parade from a balcony and later joins a friend at street level.",
        partnerA:
            "You know the balcony viewpoint and need to explain the move to the street.",
        partnerB:
            "You know the street meeting point and need to locate it relative to the balcony.",
        transferTwist:
            "A viewer interprets the new viewpoint as a new building.",
        conceptQuestion:
            "What distinguishes a viewpoint change from an accidental inconsistency?",
        conceptAnswers: [
          "The narrative explains how the new view relates to the established scene.",
          "The signer uses a different location without any contextual transition.",
          "Every new viewpoint must introduce unrelated characters.",
        ],
        rubric: [
          "Creates a stable spatial setting",
          "Marks an intentional viewpoint transition",
          "Repairs a viewer’s spatial confusion",
        ],
        prerequisiteIds: ["sequence-and-time-shifts"],
        referenceUrls: [
          "https://www.lifeprint.com/asl101/pages-layout/grammar.htm",
          "https://www.rit.edu/ntid/slpi",
        ],
      ),
      ProgramUnitBlueprint(
        id: "a-change-of-perspective",
        title: "A change of perspective",
        objectives: [
          "Identify who a perspective belongs to",
          "Separate narrator knowledge from character knowledge",
        ],
        vocabulary: [
          "role shift",
          "perspective",
          "character",
          "gaze",
          "narrator",
          "knowledge",
        ],
        grammarFocus:
            "Role shift and constructed dialogue coordinate context, gaze, body orientation, and nonmanual features. A body movement alone does not establish a character.",
        cultureFocus:
            "Represent a character fairly; do not caricature a community or identity through expression.",
        receptiveTask:
            "Identify speaker and viewpoint in approved two-character narratives, including the return to narrator.",
        expressiveTask:
            "Rehearse a two-character event with taught perspective shifts and explicit character establishment.",
        scenario:
            "One friend thinks an umbrella is lost; another knows it was moved beside the door.",
        partnerA:
            "You represent the friend who does not yet know where the umbrella is.",
        partnerB:
            "You represent the friend who moved it and must explain the new location.",
        transferTwist:
            "The narrator knows the answer before the first character learns it.",
        conceptQuestion:
            "What must stay distinct in a perspective-based story?",
        conceptAnswers: [
          "What the narrator knows and what each character knows at that moment.",
          "Every character must know all information the narrator has.",
          "Any change in facial expression creates a new named character.",
        ],
        rubric: [
          "Establishes each character",
          "Maintains viewpoint and knowledge distinctions",
          "Returns clearly to narrator",
        ],
        prerequisiteIds: ["setting-and-perspective"],
        referenceUrls: [
          "https://www.lifeprint.com/asl101/pages-layout/grammar.htm",
          "https://www.rit.edu/ntid/slpi",
        ],
      ),
      ProgramUnitBlueprint(
        id: "constructed-action",
        title: "Action through a character",
        objectives: [
          "Represent a character’s action coherently",
          "Coordinate action with the surrounding narration",
        ],
        vocabulary: [
          "constructed action",
          "body",
          "gaze",
          "character",
          "event",
          "narrator",
        ],
        grammarFocus:
            "Constructed action depicts aspects of a referent’s behavior within discourse; it integrates with language and must be studied in contextual fluent examples.",
        cultureFocus:
            "Represent actions without mocking an individual’s body, disability, or identity.",
        receptiveTask:
            "Identify when an approved narrator depicts a character’s action and how the surrounding discourse identifies that character.",
        expressiveTask:
            "Use a taught constructed-action passage within a short event and make its boundaries clear.",
        scenario:
            "A character carefully carries a full cup through a busy room and pauses at a narrow doorway.",
        partnerA:
            "You know what the character is carrying and where the doorway is.",
        partnerB:
            "You need to understand why the character pauses rather than continues.",
        transferTwist:
            "Another person helps, and the acting perspective changes briefly.",
        conceptQuestion:
            "What makes constructed action understandable within a story?",
        conceptAnswers: [
          "A clear referent, meaningful action, and connection to the surrounding discourse.",
          "Any dramatic movement regardless of which character performs it.",
          "Removing all contextual language because action must be self-explanatory.",
        ],
        rubric: [
          "Identifies the acting referent",
          "Coordinates taught action with context",
          "Marks transitions into and out of depiction",
        ],
        prerequisiteIds: ["a-change-of-perspective"],
        referenceUrls: [
          "https://www.lifeprint.com/asl101/pages-layout/grammar.htm",
          "https://www.rit.edu/ntid/slpi",
        ],
      ),
      ProgramUnitBlueprint(
        id: "dialogue-and-narrator",
        title: "Dialogue and the narrator",
        objectives: [
          "Track a multi-turn quoted exchange",
          "Return to narration without ambiguity",
        ],
        vocabulary: [
          "dialogue",
          "turn",
          "narrator",
          "quotation",
          "response",
          "role",
        ],
        grammarFocus:
            "Constructed dialogue represents an exchange while narration organizes the event; role boundaries and referents must remain clear across turns.",
        cultureFocus:
            "Distinguish an approximate retelling from a claim to reproduce someone’s exact words or signing.",
        receptiveTask:
            "Label the speaker for each turn in an approved two-person dialogue embedded in narration.",
        expressiveTask:
            "Retell a short exchange and add a narrator explanation without attributing it to a character.",
        scenario:
            "Two friends disagree about a meeting time; the narrator later explains that one read an old message.",
        partnerA:
            "You know the first friend expected 2 and want the second friend’s reasoning.",
        partnerB: "You expected 3 because an updated message changed the time.",
        transferTwist:
            "The narrator explains the old message between two dialogue turns.",
        conceptQuestion:
            "How can a narrator’s explanation avoid being mistaken for a character’s turn?",
        conceptAnswers: [
          "Clearly mark the return to narration and reestablish the next dialogue role.",
          "Keep every explanation in the last character’s perspective without context.",
          "Assume viewers will infer role boundaries from the English topic alone.",
        ],
        rubric: [
          "Tracks dialogue turns accurately",
          "Separates narrator commentary",
          "Reestablishes roles after an interruption",
        ],
        prerequisiteIds: ["constructed-action"],
        referenceUrls: [
          "https://www.lifeprint.com/asl101/pages-layout/grammar.htm",
          "https://www.rit.edu/ntid/slpi",
        ],
      ),
      ProgramUnitBlueprint(
        id: "description-in-motion",
        title: "A moving scene",
        objectives: [
          "Track several entities across an event",
          "Preserve relative locations as motion changes",
        ],
        vocabulary: [
          "entity",
          "path",
          "speed",
          "obstacle",
          "location",
          "relative movement",
        ],
        grammarFocus:
            "Dynamic spatial narration requires consistent referents, appropriate depicting forms, and meaningful movement changes, not arbitrary animation.",
        cultureFocus:
            "Depiction is linguistic expression; do not judge it only by how entertaining or physically large it looks.",
        receptiveTask:
            "Trace two entities’ paths in a reviewed narrative and identify where their relationship changes.",
        expressiveTask:
            "Describe a taught two-entity movement scene with a stationary landmark and a clear endpoint.",
        scenario:
            "A cyclist passes a walker near a bench, then stops at the corner while the walker continues.",
        partnerA:
            "You know where the cyclist stops and need to explain the relative paths.",
        partnerB:
            "You need to know which person continues and which remains at the corner.",
        transferTwist:
            "A viewer confuses the stationary bench with the stopped cyclist.",
        conceptQuestion:
            "What must be maintained when one entity stops and another continues?",
        conceptAnswers: [
          "Distinct entity references and their changing spatial relationships.",
          "The same movement for both because they began in the same scene.",
          "A new arbitrary location for every entity after each action.",
        ],
        rubric: [
          "Distinguishes all relevant entities",
          "Maintains paths and relative positions",
          "Clarifies a changed movement state",
        ],
        prerequisiteIds: ["dialogue-and-narrator"],
        referenceUrls: [
          "https://www.lifeprint.com/asl101/pages-layout/grammar.htm",
          "https://www.rit.edu/ntid/slpi",
        ],
      ),
      ProgramUnitBlueprint(
        id: "cause-and-consequence",
        title: "Why the event changed",
        objectives: [
          "Distinguish an event’s cause from a guess",
          "Connect a consequence to the right event",
        ],
        vocabulary: [
          "cause",
          "consequence",
          "evidence",
          "assumption",
          "result",
          "explanation",
        ],
        grammarFocus:
            "Causal discourse should show which claim explains which event. Sequence alone does not prove a causal relationship.",
        cultureFocus:
            "Avoid attributing motives or blame beyond the evidence in the story.",
        receptiveTask:
            "Identify stated causes, observed results, and character guesses in an approved narrative.",
        expressiveTask:
            "Retell an event while distinguishing what happened from what a character initially assumed.",
        scenario:
            "A display falls after a door opens, but a loose support is later found behind it.",
        partnerA:
            "You witnessed the timing but did not see what caused the fall.",
        partnerB:
            "You later found the loose support and can explain the new evidence.",
        transferTwist:
            "A listener assumes the person opening the door must be responsible.",
        conceptQuestion: "What can event order alone establish?",
        conceptAnswers: [
          "That one event preceded another, not necessarily that it caused it.",
          "That the earlier event is always the sole cause.",
          "That a character’s first explanation is confirmed evidence.",
        ],
        rubric: [
          "Separates observation and inference",
          "Connects explanations to evidence",
          "Revises an initial causal assumption",
        ],
        prerequisiteIds: ["description-in-motion"],
        referenceUrls: [
          "https://www.lifeprint.com/asl101/pages-layout/grammar.htm",
          "https://www.rit.edu/ntid/slpi",
        ],
      ),
      ProgramUnitBlueprint(
        id: "suspense-and-reveal",
        title: "Keep the audience curious",
        objectives: [
          "Control which information is revealed",
          "Make a resolution follow established clues",
        ],
        vocabulary: [
          "clue",
          "expectation",
          "reveal",
          "suspense",
          "evidence",
          "resolution",
        ],
        grammarFocus:
            "Narrative pacing organizes information for an audience while preserving coherent referents and temporal relationships.",
        cultureFocus:
            "Suspense should not depend on stereotypes or withholding essential access to the language.",
        receptiveTask:
            "Identify which clues an approved narrative reveals before its resolution and which assumptions they invite.",
        expressiveTask:
            "Tell a short mystery with two relevant clues and a resolution that fits them.",
        scenario:
            "A familiar key appears on a café counter, but nobody recognizes the small tag attached to it.",
        partnerA:
            "You know where the key was found and what its tag looks like.",
        partnerB:
            "You recognize the tag as belonging to a storage cupboard, not a house.",
        transferTwist:
            "The audience assumes the key belongs to the most recently introduced person.",
        conceptQuestion: "What makes a narrative reveal coherent?",
        conceptAnswers: [
          "It connects to established clues and revises assumptions without contradicting known facts.",
          "It introduces an unrelated solution with no connection to earlier information.",
          "It treats every audience guess as a fact that must be preserved.",
        ],
        rubric: [
          "Provides relevant clues",
          "Controls information without losing clarity",
          "Resolves the story consistently",
        ],
        prerequisiteIds: ["cause-and-consequence"],
        referenceUrls: [
          "https://www.lifeprint.com/asl101/pages-layout/grammar.htm",
          "https://www.rit.edu/ntid/slpi",
        ],
      ),
      ProgramUnitBlueprint(
        id: "repairing-a-narrative",
        title: "When the audience loses the thread",
        objectives: [
          "Locate a narrative misunderstanding",
          "Rephrase while preserving established facts",
        ],
        vocabulary: [
          "clarification",
          "referent",
          "sequence",
          "rephrase",
          "perspective",
          "feedback",
        ],
        grammarFocus:
            "Narrative repair can reestablish a referent, time frame, or viewpoint; restarting every detail is not always necessary.",
        cultureFocus:
            "Treat viewer feedback as useful information, not as failure or disrespect.",
        receptiveTask:
            "Compare an original and revised approved passage and identify the confusion that the revision resolves.",
        expressiveTask:
            "Tell a short event, receive a focused question, and repair the relevant passage.",
        scenario:
            "Your viewer cannot tell whether Jo or Pat returned the missing folder.",
        partnerA: "You know Pat returned it, after Jo asked about it.",
        partnerB:
            "You understand the folder was returned but need the actor clarified.",
        transferTwist:
            "Clarifying the actor reveals a second confusion about the time sequence.",
        conceptQuestion:
            "Which repair is most useful when the actor is unclear?",
        conceptAnswers: [
          "Reestablish the relevant people and explicitly clarify who performed the action.",
          "Add unrelated descriptive detail while leaving the actor ambiguous.",
          "Repeat the same unclear referent more quickly.",
        ],
        rubric: [
          "Identifies the viewer’s actual confusion",
          "Repairs the relevant reference",
          "Checks the revised interpretation",
        ],
        prerequisiteIds: ["suspense-and-reveal"],
        referenceUrls: [
          "https://www.lifeprint.com/asl101/pages-layout/grammar.htm",
          "https://www.rit.edu/ntid/slpi",
        ],
      ),
      ProgramUnitBlueprint(
        id: "the-missing-sketchbook",
        title: "The missing sketchbook",
        objectives: [
          "Integrate clues and perspectives",
          "Retell a changing interpretation accurately",
        ],
        vocabulary: [
          "sketchbook",
          "clue",
          "observation",
          "assumption",
          "lost property",
          "resolution",
        ],
        grammarFocus:
            "Integrate narrative sequence, consistent spatial reference, perspective, and the distinction between belief and later knowledge.",
        cultureFocus:
            "Do not turn an uncertain observation into an accusation about another person.",
        receptiveTask:
            "Follow approved episodes of the mystery and update an evidence map after each new clue.",
        expressiveTask:
            "Retell the mystery with a clear initial belief, new evidence, and final resolution.",
        scenario:
            "Your green sketchbook disappears from a café table. A worker moved it to lost property before cleaning.",
        partnerA:
            "You know the cover has a star sticker and that it was left by the window.",
        partnerB:
            "You moved a green notebook; ask for the sticker detail before confirming ownership.",
        transferTwist: "A second green notebook appears in lost property.",
        conceptQuestion:
            "What confirms the notebook’s identity more reliably than color alone?",
        conceptAnswers: [
          "A distinguishing known detail, such as the star sticker, checked against the item.",
          "The assumption that only one green notebook can exist.",
          "The fact that someone carried any book toward the door.",
        ],
        rubric: [
          "Maintains scene and character references",
          "Separates clues from assumptions",
          "Explains the confirmed resolution",
        ],
        prerequisiteIds: ["repairing-a-narrative"],
        referenceUrls: [
          "https://www.lifeprint.com/asl101/pages-layout/grammar.htm",
          "https://www.rit.edu/ntid/slpi",
        ],
      ),
      ProgramUnitBlueprint(
        id: "narrative-portfolio",
        title: "A story that holds together",
        objectives: [
          "Prepare varied narrative evidence",
          "Revise after qualified feedback",
        ],
        vocabulary: [
          "portfolio",
          "narrative",
          "viewer",
          "rubric",
          "revision",
          "reflection",
        ],
        grammarFocus:
            "Coherent narrative performance involves reference, sequence, perspective, nonmanual grammar, and comprehensibility across a whole sample.",
        cultureFocus:
            "Obtain consent for any partner recording and distinguish original work from attributed material.",
        receptiveTask:
            "Compare two consented reviewed narratives and identify different effective organizational choices.",
        expressiveTask:
            "Prepare an original narrative, obtain specific fluent feedback, and revise one important passage.",
        scenario:
            "You select a personal event and a fictional scene to demonstrate different narrative demands.",
        partnerA:
            "You are the storyteller and want feedback on a perspective transition.",
        partnerB:
            "You are the consenting viewer; identify where you lose track and ask a focused question.",
        transferTwist:
            "An unfamiliar viewer notices a problem your familiar partner had inferred correctly.",
        conceptQuestion: "What offers stronger evidence of narrative growth?",
        conceptAnswers: [
          "A clearer revised sample with specific feedback on the communicative task.",
          "Only an increased number of recorded attempts.",
          "A faster retelling regardless of whether an unfamiliar viewer follows it.",
        ],
        rubric: [
          "Produces a coherent complete narrative",
          "Uses specific external feedback",
          "Demonstrates a meaningful revision",
        ],
        prerequisiteIds: ["the-missing-sketchbook"],
        referenceUrls: [
          "https://gallaudet.edu/american-sign-language-proficiency-interview-aslpi/aslpi-preparation/aslpi-proficiency-levels/",
          "https://www.rit.edu/ntid/slpi",
        ],
      ),
    ],
  ),
  ProgramBandBlueprint(
    id: "in-the-community",
    title: "In the community",
    subtitle: "Upper intermediate",
    description:
        "Participate in longer and group exchanges, explore identity and variation, and collaborate with attention to access and community context.",
    units: [
      ProgramUnitBlueprint(
        id: "joining-the-conversation",
        title: "Joining the conversation",
        objectives: [
          "Track several participants",
          "Enter an exchange with a relevant contribution",
        ],
        vocabulary: [
          "group",
          "turn",
          "attention",
          "contribution",
          "sightline",
          "topic",
        ],
        grammarFocus:
            "Group discourse requires tracking the current signer, referents, and turn opportunities; a contribution should connect to the ongoing topic.",
        cultureFocus:
            "Arrange usable sightlines and avoid blocking other participants’ visual access.",
        receptiveTask:
            "Follow an approved small-group exchange and identify who introduces, supports, and questions a proposal.",
        expressiveTask:
            "Contribute to a consenting three-person practice group and respond to a preceding point.",
        scenario: "Three club members discuss where to hold the next meeting.",
        partnerA:
            "You prefer the library because it is familiar; ask about the other location.",
        partnerB:
            "You know the other room has a circular seating layout but a later opening time.",
        transferTwist:
            "A new participant joins after the first option was discussed.",
        conceptQuestion: "What makes a group contribution relevant?",
        conceptAnswers: [
          "It connects to the current topic and acknowledges information already shared.",
          "It repeats a prepared speech regardless of the prior turns.",
          "It begins whenever an idea occurs, even if another person is signing.",
        ],
        rubric: [
          "Tracks speakers and topic",
          "Enters at a suitable turn",
          "Contributes connected information",
        ],
        prerequisiteIds: ["narrative-portfolio"],
        referenceUrls: [
          "https://www.nad.org/resources/american-sign-language/community-and-culture-frequently-asked-questions/",
          "https://nad.org/who-we-are/our-language/",
        ],
      ),
      ProgramUnitBlueprint(
        id: "topic-management",
        title: "Hold and change a topic",
        objectives: [
          "Recognize a topic transition",
          "Return to an earlier point clearly",
        ],
        vocabulary: [
          "topic",
          "transition",
          "reference",
          "aside",
          "return",
          "clarification",
        ],
        grammarFocus:
            "Discourse needs recognizable links when a topic shifts, an aside is introduced, or an earlier referent is resumed.",
        cultureFocus:
            "Manage turns so one participant’s long contribution does not erase others’ opportunities.",
        receptiveTask:
            "Map the topic progression in a reviewed group exchange and distinguish an aside from a new main topic.",
        expressiveTask:
            "Introduce a relevant new topic, then return to an unfinished point using taught discourse resources.",
        scenario:
            "A meeting moves from choosing a room to planning refreshments before the room is confirmed.",
        partnerA:
            "You want to return to the unresolved room decision without dismissing the food discussion.",
        partnerB:
            "You introduced refreshments but can summarize the unresolved room options.",
        transferTwist:
            "A participant mistakes the refreshments discussion for confirmation of the room.",
        conceptQuestion: "How should an unresolved earlier point be resumed?",
        conceptAnswers: [
          "Explicitly connect back to that point and clarify what remains undecided.",
          "Assume mentioning it earlier means the decision was already made.",
          "Change referents silently and expect everyone to infer the return.",
        ],
        rubric: [
          "Recognizes topic structure",
          "Signals a clear return",
          "Keeps unresolved and settled points distinct",
        ],
        prerequisiteIds: ["joining-the-conversation"],
        referenceUrls: [
          "https://www.lifeprint.com/asl101/pages-layout/grammar.htm",
          "https://www.rit.edu/ntid/slpi",
        ],
      ),
      ProgramUnitBlueprint(
        id: "opinions-and-evidence",
        title: "An opinion with support",
        objectives: [
          "State a position and relevant reasons",
          "Distinguish evidence from preference",
        ],
        vocabulary: [
          "opinion",
          "evidence",
          "reason",
          "example",
          "claim",
          "uncertainty",
        ],
        grammarFocus:
            "Extended opinion discourse should connect claims to reasons and examples while marking their scope and certainty.",
        cultureFocus:
            "Represent another person’s view accurately before disagreeing with it.",
        receptiveTask:
            "Identify a claim, a supporting example, and an unsupported inference in approved discussion.",
        expressiveTask:
            "Present a low-stakes opinion with two reasons and invite a substantive response.",
        scenario:
            "A club compares meeting in the morning with meeting in the evening.",
        partnerA:
            "You prefer evenings; your attendance poll includes only five respondents.",
        partnerB:
            "You prefer mornings and know several members who have not answered the poll.",
        transferTwist:
            "New responses change which time appears most accessible.",
        conceptQuestion: "What can a small attendance poll support?",
        conceptAnswers: [
          "A limited observation about its respondents, with broader conclusions kept tentative.",
          "A certain statement about every member’s availability.",
          "The claim that a personal preference has become an established fact.",
        ],
        rubric: [
          "States a clear position",
          "Links reasons to appropriate evidence",
          "Adjusts certainty when evidence is limited",
        ],
        prerequisiteIds: ["topic-management"],
        referenceUrls: [
          "https://www.lifeprint.com/asl101/pages-layout/grammar.htm",
          "https://www.rit.edu/ntid/slpi",
        ],
      ),
      ProgramUnitBlueprint(
        id: "negotiating-decisions",
        title: "Find a workable agreement",
        objectives: [
          "Compare options against shared needs",
          "Confirm a decision and remaining concerns",
        ],
        vocabulary: [
          "negotiate",
          "constraint",
          "compromise",
          "option",
          "priority",
          "agreement",
        ],
        grammarFocus:
            "Negotiation tracks proposals, conditions, objections, and the final scope of agreement across several turns.",
        cultureFocus:
            "A majority preference does not automatically resolve a participant’s access barrier.",
        receptiveTask:
            "Follow an approved negotiation and identify which constraints each accepted option satisfies.",
        expressiveTask:
            "Negotiate an event arrangement with two competing priorities and confirm unresolved details.",
        scenario:
            "The group wants an inexpensive room with good visual access and public transport nearby.",
        partnerA: "You know Room A is cheaper but has a fixed row layout.",
        partnerB:
            "You know Room B has movable seating and transit access but a higher cost.",
        transferTwist:
            "A participant offers a budget adjustment that makes Room B possible.",
        conceptQuestion: "What makes an agreement workable?",
        conceptAnswers: [
          "Its relevant constraints are addressed and participants understand the decision and open issues.",
          "The first proposal is accepted before constraints are discussed.",
          "A preference vote removes the need to consider access.",
        ],
        rubric: [
          "Tracks competing constraints",
          "Responds to new options",
          "Confirms the scope of agreement",
        ],
        prerequisiteIds: ["opinions-and-evidence"],
        referenceUrls: [
          "https://www.lifeprint.com/asl101/pages-layout/grammar.htm",
          "https://www.rit.edu/ntid/slpi",
        ],
      ),
      ProgramUnitBlueprint(
        id: "language-and-identity",
        title: "Language and identity",
        objectives: [
          "Discuss identity without universalizing",
          "Use self-chosen terms accurately",
        ],
        vocabulary: [
          "Deaf",
          "deaf",
          "hard of hearing",
          "identity",
          "language history",
          "preference",
        ],
        grammarFocus:
            "Distinguish an individual account from a statement about a whole community; reference and attribution should preserve whose experience is described.",
        cultureFocus:
            "Identities and communication preferences are personal and varied; learn directly from multiple Deaf perspectives.",
        receptiveTask:
            "Compare authorized first-person accounts and identify similarities without erasing differences.",
        expressiveTask:
            "Summarize a person’s self-description accurately and reflect on your own learning perspective.",
        scenario:
            "Two community contributors describe different language histories and preferred identity terms.",
        partnerA:
            "Contributor A values one identity term; summarize that choice without applying it to everyone.",
        partnerB:
            "Contributor B chooses a different term and a different communication arrangement.",
        transferTwist: "A listener assumes one account invalidates the other.",
        conceptQuestion:
            "What follows when two people choose different identity terms?",
        conceptAnswers: [
          "Their individual choices should be represented accurately without forcing one universal label.",
          "One person must be corrected so the descriptions match.",
          "The learner should select a label for both based on appearance.",
        ],
        rubric: [
          "Attributes experiences to the right person",
          "Uses self-chosen terms",
          "Avoids universal claims from one account",
        ],
        prerequisiteIds: ["negotiating-decisions"],
        referenceUrls: [
          "https://www.nad.org/resources/american-sign-language/community-and-culture-frequently-asked-questions/",
          "https://nad.org/who-we-are/our-language/",
        ],
      ),
      ProgramUnitBlueprint(
        id: "regional-and-social-variation",
        title: "Variation belongs to language",
        objectives: [
          "Recognize context-dependent variants",
          "Document a variant without ranking identities",
        ],
        vocabulary: [
          "variant",
          "region",
          "generation",
          "community",
          "register",
          "context",
        ],
        grammarFocus:
            "Lexical and discourse variation must be understood in community and context; a difference from a classroom form is not sufficient evidence of error.",
        cultureFocus:
            "Study Black ASL and other varieties through community scholars and signers rather than treating variation as a novelty.",
        receptiveTask:
            "Compare licensed examples of a taught concept from varied signers and note context supplied by the educators.",
        expressiveTask:
            "Discuss a reviewed variant and identify where you learned it, without imitating an identity or inventing its scope.",
        scenario:
            "Two educators demonstrate different accepted forms for a familiar concept.",
        partnerA:
            "You learned form A in one region and want to understand form B’s use.",
        partnerB:
            "You know form B’s context but cannot claim it is used by every community member.",
        transferTwist: "A scoring system marks one accepted variant incorrect.",
        conceptQuestion:
            "What is needed before calling an unfamiliar form an error?",
        conceptAnswers: [
          "Contextual linguistic evidence and informed review, including the possibility of a valid variant.",
          "Only a mismatch with the first version stored in an app.",
          "An assumption that every regional difference has the same distribution.",
        ],
        rubric: [
          "Recognizes variation without automatic correction",
          "Documents the source and context",
          "Distinguishes evidence from assumptions about communities",
        ],
        prerequisiteIds: ["language-and-identity"],
        referenceUrls: [
          "https://gallaudet.edu/center-black-deaf-studies/black-asl-project/",
          "https://www.lifeprint.com/asl101/pages-layout/grammar.htm",
        ],
      ),
      ProgramUnitBlueprint(
        id: "deaf-history-and-agency",
        title: "History through Deaf perspectives",
        objectives: [
          "Attribute historical accounts",
          "Connect language history to community agency",
        ],
        vocabulary: [
          "history",
          "language rights",
          "organization",
          "source",
          "perspective",
          "agency",
        ],
        grammarFocus:
            "Historical discourse separates chronology, source attribution, and interpretation; different accounts may foreground different experiences.",
        cultureFocus:
            "Center Deaf-authored primary accounts and avoid portraying Deaf people only as passive recipients of others’ actions.",
        receptiveTask:
            "Study an authorized signed historical account and identify the people, time frame, and perspective of its source.",
        expressiveTask:
            "Summarize a short sourced account and clearly distinguish the source’s claims from your reflection.",
        scenario:
            "A discussion group compares two accounts of a community organization’s founding.",
        partnerA:
            "Your account highlights the founders’ language-rights goals.",
        partnerB:
            "Your account describes later access campaigns and must not be substituted for the founding timeline.",
        transferTwist:
            "A listener confuses a later campaign with the original founding event.",
        conceptQuestion:
            "How should a learner present a historical interpretation?",
        conceptAnswers: [
          "Identify its source and time frame, distinguishing evidence from personal interpretation.",
          "Treat every retelling as a direct primary account.",
          "Omit Deaf participants’ agency because institutions alone explain the events.",
        ],
        rubric: [
          "Maintains a supported chronology",
          "Attributes historical claims",
          "Represents Deaf agency accurately",
        ],
        prerequisiteIds: ["regional-and-social-variation"],
        referenceUrls: [
          "https://nad.org/who-we-are/our-language/",
          "https://gallaudet.edu/museum/exhibits/history-through-deaf-eyes/awareness-access-and-change/american-sign-language-a-language-recognized/",
        ],
      ),
      ProgramUnitBlueprint(
        id: "access-and-collaboration",
        title: "Access is a shared design task",
        objectives: [
          "Ask about access requirements",
          "Negotiate a usable communication setup",
        ],
        vocabulary: [
          "access",
          "sightline",
          "caption",
          "interpreter",
          "preference",
          "arrangement",
        ],
        grammarFocus:
            "Clarification should distinguish a stated access requirement from a guessed preference, then confirm the agreed action and responsible person.",
        cultureFocus:
            "Ask participants what they need; no single technology or communication mode works for everyone.",
        receptiveTask:
            "Identify requested arrangements and unresolved responsibilities in a reviewed planning exchange.",
        expressiveTask:
            "Ask about preferences, summarize a concrete arrangement, and confirm who will implement it.",
        scenario:
            "A group plans a hybrid art discussion with participants joining in different ways.",
        partnerA:
            "You organize the room and need each participant’s communication requirements.",
        partnerB:
            "You join remotely and need an unobstructed full signing view; ask who will monitor it.",
        transferTwist:
            "A screen-share layout unexpectedly hides the active signer.",
        conceptQuestion: "What should an access plan specify?",
        conceptAnswers: [
          "The participants’ actual requirements, a concrete arrangement, and responsibility for making it work.",
          "A single assumed preference assigned to everyone with the same label.",
          "Only the existence of technology, without checking whether it provides access.",
        ],
        rubric: [
          "Elicits individual requirements",
          "Confirms a concrete usable arrangement",
          "Responds when the arrangement fails",
        ],
        prerequisiteIds: ["deaf-history-and-agency"],
        referenceUrls: [
          "https://www.nad.org/resources/american-sign-language/community-and-culture-frequently-asked-questions/",
          "https://nad.org/who-we-are/our-language/",
        ],
      ),
      ProgramUnitBlueprint(
        id: "digital-signing-spaces",
        title: "Signing across a screen",
        objectives: [
          "Maintain visual access remotely",
          "Repair a technology-related misunderstanding",
        ],
        vocabulary: [
          "video call",
          "framing",
          "delay",
          "interruption",
          "privacy",
          "repair",
        ],
        grammarFocus:
            "A network freeze, an incomplete frame, and an unfamiliar construction are different sources of misunderstanding and call for different repairs.",
        cultureFocus:
            "Ask before recording or sharing a signed interaction; a visible video call is not consent to distribution.",
        receptiveTask:
            "Identify whether a reviewed example becomes unclear because of capture quality or language content.",
        expressiveTask:
            "Explain a technical interruption, restore a usable view, and resume the correct conversational point.",
        scenario:
            "A call freezes as your partner gives the final location in a plan.",
        partnerA:
            "You understood the day and time; explain that the location was lost during a freeze.",
        partnerB:
            "You can repeat the location but need to know whether the video is usable again.",
        transferTwist:
            "The camera view returns mirrored differently from the earlier preview.",
        conceptQuestion: "What should you clarify after a video freeze?",
        conceptAnswers: [
          "Which segment was lost and whether the visual connection is restored.",
          "That the partner’s grammar must be wrong because the message was missed.",
          "That all prior confirmed information must now be false.",
        ],
        rubric: [
          "Distinguishes technical and linguistic uncertainty",
          "Requests the missing segment",
          "Resumes from shared information",
        ],
        prerequisiteIds: ["access-and-collaboration"],
        referenceUrls: [
          "https://www.nad.org/resources/american-sign-language/community-and-culture-frequently-asked-questions/",
          "https://nad.org/who-we-are/our-language/",
        ],
      ),
      ProgramUnitBlueprint(
        id: "workplace-collaboration",
        title: "Work together clearly",
        objectives: [
          "Explain a task and responsibility",
          "Confirm a handoff without ambiguity",
        ],
        vocabulary: [
          "task",
          "responsibility",
          "deadline",
          "handoff",
          "status",
          "clarification",
        ],
        grammarFocus:
            "A task handoff identifies actor, action, object, deadline, and completion criteria; an acknowledgment alone may not confirm all details.",
        cultureFocus:
            "Practice ordinary collaboration rather than presenting language coursework as professional interpreting qualification.",
        receptiveTask:
            "Extract responsibilities and unresolved details from an approved fictional project meeting.",
        expressiveTask:
            "Explain one task, receive a clarification, and confirm the handoff with learned workplace language.",
        scenario:
            "A volunteer team is preparing a display, a sign-in desk, and a supply table.",
        partnerA:
            "You will prepare the display by Friday but need to know who provides labels.",
        partnerB:
            "You provide labels only after receiving the final item list.",
        transferTwist:
            "The deadline stays the same but one prerequisite arrives late.",
        conceptQuestion: "What makes a task handoff clear?",
        conceptAnswers: [
          "The responsible person, deliverable, dependencies, and deadline are understood.",
          "A general nod establishes every task detail without explanation.",
          "Naming a person alone specifies what they must do.",
        ],
        rubric: [
          "Assigns actor and action clearly",
          "Identifies dependencies and deadlines",
          "Confirms shared expectations",
        ],
        prerequisiteIds: ["digital-signing-spaces"],
        referenceUrls: [
          "https://www.lifeprint.com/asl101/pages-layout/grammar.htm",
          "https://www.rit.edu/ntid/slpi",
        ],
      ),
      ProgramUnitBlueprint(
        id: "community-in-action",
        title: "Community in action",
        objectives: [
          "Plan an event with several people",
          "Update an agreement when circumstances change",
        ],
        vocabulary: [
          "event",
          "responsibility",
          "update",
          "access",
          "feedback",
          "improvement",
        ],
        grammarFocus:
            "Longer collaborative discourse must preserve references and distinguish confirmed decisions, changes, and open questions.",
        cultureFocus:
            "Affected participants should help shape decisions; do not replace their input with assumptions about access.",
        receptiveTask:
            "Follow approved event-planning segments and update a decision map as details change.",
        expressiveTask:
            "Present a concise proposal, invite feedback, and revise one part of the plan.",
        scenario:
            "A group plans an art afternoon, then learns the original studio is unavailable.",
        partnerA:
            "You know the alternative studio is larger and need to confirm the schedule.",
        partnerB:
            "You know the same time is available but the entrance and seating plan differ.",
        transferTwist:
            "A participant raises an access concern after the new room is proposed.",
        conceptQuestion: "How should a changed event plan be communicated?",
        conceptAnswers: [
          "Identify what changed, what remains confirmed, and what still requires input.",
          "Mention all old and new details without labeling their status.",
          "Treat every concern as resolved once a replacement room is named.",
        ],
        rubric: [
          "Separates confirmed changed and open details",
          "Invites relevant participant input",
          "Produces a coherent updated plan",
        ],
        prerequisiteIds: ["workplace-collaboration"],
        referenceUrls: [
          "https://www.lifeprint.com/asl101/pages-layout/grammar.htm",
          "https://www.rit.edu/ntid/slpi",
        ],
      ),
      ProgramUnitBlueprint(
        id: "community-portfolio",
        title: "Participation with purpose",
        objectives: [
          "Sustain an unscripted group exchange",
          "Use feedback to improve participation",
        ],
        vocabulary: [
          "portfolio",
          "group interaction",
          "contribution",
          "feedback",
          "reflection",
          "goals",
        ],
        grammarFocus:
            "Group competence includes receptive tracking, connected contribution, repair, and discourse management rather than isolated vocabulary performance.",
        cultureFocus:
            "Document only consented participation and compensate qualified reviewers; community contact is not a free assessment service.",
        receptiveTask:
            "Review a consented group sample and identify where each contribution responds to prior information.",
        expressiveTask:
            "Participate in an agreed group task and ask for specific feedback on one discourse skill.",
        scenario:
            "A consenting practice group must choose an event plan from options with different constraints.",
        partnerA:
            "You contribute one researched option and remain open to revision.",
        partnerB:
            "You contribute an unannounced constraint and evaluate how the group responds.",
        transferTwist:
            "An unfamiliar signer joins and the group adjusts to their communication preferences.",
        conceptQuestion: "What demonstrates progress in group participation?",
        conceptAnswers: [
          "Following and contributing to changing interaction with specific feedback on its effectiveness.",
          "Speaking longest or using the largest vocabulary list.",
          "Receiving an app completion badge without an actual group exchange.",
        ],
        rubric: [
          "Tracks changing group information",
          "Makes relevant contributions and repairs",
          "Identifies a specific next goal from feedback",
        ],
        prerequisiteIds: ["community-in-action"],
        referenceUrls: [
          "https://gallaudet.edu/american-sign-language-proficiency-interview-aslpi/aslpi-preparation/aslpi-proficiency-levels/",
          "https://www.rit.edu/ntid/slpi",
        ],
      ),
    ],
  ),
  ProgramBandBlueprint(
    id: "beyond-the-familiar",
    title: "Beyond the familiar",
    subtitle: "Advanced and expert practice",
    description:
        "Develop depth, nuance, register, literary understanding, and sustained spontaneous interaction through authentic work and qualified review.",
    units: [
      ProgramUnitBlueprint(
        id: "ideas-with-depth",
        title: "Ideas with depth",
        objectives: [
          "Organize an extended explanation",
          "Adapt detail to the audience’s knowledge",
        ],
        vocabulary: [
          "explanation",
          "concept",
          "example",
          "audience",
          "structure",
          "clarification",
        ],
        grammarFocus:
            "Extended discourse needs clear organization, maintained reference, examples, and checks for understanding; breadth of vocabulary alone does not ensure coherence.",
        cultureFocus:
            "Expertise in a topic does not automatically imply the ability to explain it accessibly in ASL.",
        receptiveTask:
            "Outline an approved extended explanation and identify which examples clarify which concepts.",
        expressiveTask:
            "Explain a familiar process to a partner, then respond to an unplanned request for elaboration.",
        scenario:
            "You explain how a lending library tracks items from donation to checkout and return.",
        partnerA:
            "You know the intake and catalog stages but need to connect them to checkout.",
        partnerB:
            "You know checkout rules and ask why an item cannot be borrowed before cataloging.",
        transferTwist:
            "Your partner lacks a concept you assumed they already understood.",
        conceptQuestion:
            "What should an explanation do when the audience lacks a prerequisite concept?",
        conceptAnswers: [
          "Establish that concept with an appropriate example before building on it.",
          "Continue with more specialist vocabulary at the same pace.",
          "Repeat the conclusion without clarifying the missing concept.",
        ],
        rubric: [
          "Organizes a complete explanation",
          "Uses examples that fit the audience",
          "Adapts after a comprehension question",
        ],
        prerequisiteIds: ["community-portfolio"],
        referenceUrls: [
          "https://gallaudet.edu/american-sign-language-proficiency-interview-aslpi/aslpi-preparation/aslpi-proficiency-levels/",
          "https://www.rit.edu/ntid/slpi",
        ],
      ),
      ProgramUnitBlueprint(
        id: "explaining-complex-systems",
        title: "Make a system understandable",
        objectives: [
          "Describe dependencies among stages",
          "Explain an exception without breaking the model",
        ],
        vocabulary: [
          "system",
          "dependency",
          "process",
          "exception",
          "feedback",
          "relationship",
        ],
        grammarFocus:
            "Complex explanation must maintain several referents and distinguish sequence from dependency, hierarchy, and feedback relationships.",
        cultureFocus:
            "Use a domain you understand and mark the limits of your knowledge rather than inventing authoritative details.",
        receptiveTask:
            "Reconstruct a process model from an approved explanation with one exception and one feedback loop.",
        expressiveTask:
            "Explain a familiar system, then clarify what changes when a prerequisite is missing.",
        scenario:
            "A fictional seed library receives, labels, stores, lends, and replenishes seed packets.",
        partnerA:
            "You know that unlabeled packets cannot be lent and must return to intake.",
        partnerB:
            "You know the lending stage and ask where an unlabeled packet belongs.",
        transferTwist:
            "A returned packet contains incomplete information and reenters an earlier stage.",
        conceptQuestion:
            "What distinguishes a dependency from simple event order?",
        conceptAnswers: [
          "A dependent stage requires a condition to be satisfied, not merely an earlier event to be mentioned.",
          "Any stages listed in order necessarily depend on one another.",
          "An exception means the entire process can no longer be described coherently.",
        ],
        rubric: [
          "Maintains a coherent system model",
          "Explains a specific dependency",
          "Integrates an exception and its consequences",
        ],
        prerequisiteIds: ["ideas-with-depth"],
        referenceUrls: [
          "https://www.lifeprint.com/asl101/pages-layout/grammar.htm",
          "https://www.rit.edu/ntid/slpi",
        ],
      ),
      ProgramUnitBlueprint(
        id: "conditions-and-hypotheses",
        title: "Explore a possible world",
        objectives: [
          "Distinguish a hypothetical premise from fact",
          "Track consequences within its scope",
        ],
        vocabulary: [
          "condition",
          "hypothesis",
          "possible",
          "consequence",
          "premise",
          "uncertainty",
        ],
        grammarFocus:
            "Conditional and hypothetical constructions have grammatical form and scope; study complete examples and maintain the boundary between imagined and established information.",
        cultureFocus:
            "Avoid presenting speculative consequences as facts, especially when discussing other people’s lives.",
        receptiveTask:
            "Identify a hypothetical premise, its projected consequence, and a return to real conditions in reviewed discussion.",
        expressiveTask:
            "Develop a low-stakes hypothetical and respond to a partner who changes one premise.",
        scenario:
            "You imagine turning a car park into a community garden and explore what would be needed.",
        partnerA:
            "Assume the space is available, but make clear that permission has not been granted.",
        partnerB:
            "Ask what happens if water access is unavailable in the hypothetical design.",
        transferTwist:
            "A new constraint changes only one part of the imagined plan.",
        conceptQuestion:
            "What must remain explicit while exploring a hypothetical?",
        conceptAnswers: [
          "Which premises are imagined and which claims describe established conditions.",
          "That discussing a possibility means it has already been approved.",
          "That every predicted consequence is certain once the premise is stated.",
        ],
        rubric: [
          "Establishes a hypothetical premise",
          "Maintains its scope coherently",
          "Revises consequences when a premise changes",
        ],
        prerequisiteIds: ["explaining-complex-systems"],
        referenceUrls: [
          "https://www.lifeprint.com/asl101/pages-layout/grammar.htm",
          "https://www.rit.edu/ntid/slpi",
        ],
      ),
      ProgramUnitBlueprint(
        id: "argument-and-counterargument",
        title: "Build and test an argument",
        objectives: [
          "Represent an opposing view fairly",
          "Revise a position after relevant evidence",
        ],
        vocabulary: [
          "claim",
          "support",
          "counterargument",
          "rebuttal",
          "concession",
          "evidence",
        ],
        grammarFocus:
            "Argumentation links a claim to evidence and distinguishes a response, a concession, and a revised conclusion across discourse.",
        cultureFocus:
            "Respectful disagreement requires accurate representation of another person’s position rather than attributing motives.",
        receptiveTask:
            "Map claims, support, and counterarguments in an approved extended exchange.",
        expressiveTask:
            "Present a low-stakes proposal, summarize a counterargument accurately, and respond with relevant reasoning.",
        scenario:
            "A community library considers extending opening hours with a limited volunteer budget.",
        partnerA:
            "You support evening hours because some users cannot attend earlier.",
        partnerB:
            "You support weekend hours because volunteer coverage is more reliable then.",
        transferTwist: "A new availability survey supports a blended schedule.",
        conceptQuestion:
            "What makes a response address the actual counterargument?",
        conceptAnswers: [
          "It represents the concern accurately and responds with relevant evidence or a justified revision.",
          "It replaces the concern with a weaker unrelated claim.",
          "It repeats the original conclusion without engaging the new information.",
        ],
        rubric: [
          "Connects claims to support",
          "Represents the counterargument fairly",
          "Makes a reasoned response or revision",
        ],
        prerequisiteIds: ["conditions-and-hypotheses"],
        referenceUrls: [
          "https://gallaudet.edu/american-sign-language-proficiency-interview-aslpi/aslpi-preparation/aslpi-proficiency-levels/",
          "https://www.rit.edu/ntid/slpi",
        ],
      ),
      ProgramUnitBlueprint(
        id: "interpreting-information",
        title: "Explain what the information shows",
        objectives: [
          "Distinguish data from interpretation",
          "Communicate scope and uncertainty",
        ],
        vocabulary: [
          "source",
          "pattern",
          "comparison",
          "uncertainty",
          "summary",
          "evidence",
        ],
        grammarFocus:
            "Information explanation needs clear comparisons, reference to the source, and calibrated certainty. Summarizing information is not professional language interpreting.",
        cultureFocus:
            "Credit sources and avoid turning a partial sample into a claim about an entire community.",
        receptiveTask:
            "Identify what an approved signed explanation says a simple chart supports and what remains unknown.",
        expressiveTask:
            "Explain a fictional table or chart, give one justified inference, and state one limitation.",
        scenario:
            "A fictional survey of twelve club members compares preferred meeting times; five members have not responded.",
        partnerA:
            "You know the counts among respondents and must not describe them as all members.",
        partnerB:
            "You know five responses are missing and ask whether the pattern could change.",
        transferTwist:
            "The missing responses arrive and reduce the apparent difference.",
        conceptQuestion: "How should an incomplete survey be summarized?",
        conceptAnswers: [
          "Describe the respondents’ pattern and explicitly identify the missing information.",
          "Report the pattern as certain for every club member.",
          "Treat a small difference as proof of a universal preference.",
        ],
        rubric: [
          "Communicates the actual information",
          "Distinguishes inference and fact",
          "States a material limitation",
        ],
        prerequisiteIds: ["argument-and-counterargument"],
        referenceUrls: [
          "https://www.lifeprint.com/asl101/pages-layout/grammar.htm",
          "https://www.rit.edu/ntid/slpi",
        ],
      ),
      ProgramUnitBlueprint(
        id: "register-and-audience",
        title: "One idea, different audiences",
        objectives: [
          "Adapt language to purpose and audience",
          "Preserve meaning across register changes",
        ],
        vocabulary: [
          "register",
          "audience",
          "formality",
          "purpose",
          "detail",
          "adaptation",
        ],
        grammarFocus:
            "Register affects organization, lexical choices, delivery, and discourse expectations; it is not reducible to signing speed or stiffness.",
        cultureFocus:
            "Do not rank people’s community varieties as less intelligent or less legitimate because they differ from a formal classroom register.",
        receptiveTask:
            "Compare authorized casual and formal treatments of a similar topic and identify purposeful differences.",
        expressiveTask:
            "Present the same event invitation to a close friend and to a community meeting, then seek fluent feedback.",
        scenario:
            "You announce a neighborhood art event first to a friend and then to a mixed public audience.",
        partnerA:
            "Your friend already knows the location and organizers; decide what can remain implicit.",
        partnerB:
            "The public audience lacks that context and needs purpose, location, and access details.",
        transferTwist: "An unfamiliar participant joins the casual exchange.",
        conceptQuestion: "What should guide register adaptation?",
        conceptAnswers: [
          "The audience, setting, purpose, shared knowledge, and feedback.",
          "A rule that formal ASL must always be slower and physically stiffer.",
          "An assumption that one register is equally suitable for every audience.",
        ],
        rubric: [
          "Adapts to audience knowledge",
          "Preserves the intended meaning",
          "Uses an appropriate reviewed register",
        ],
        prerequisiteIds: ["interpreting-information"],
        referenceUrls: [
          "https://gallaudet.edu/center-black-deaf-studies/black-asl-project/",
          "https://www.lifeprint.com/asl101/pages-layout/grammar.htm",
        ],
      ),
      ProgramUnitBlueprint(
        id: "art-and-expression",
        title: "A language of art",
        objectives: [
          "Recognize ASL literary form and craft",
          "Respond to a work with attribution",
        ],
        vocabulary: [
          "literature",
          "poetry",
          "narrative",
          "rhythm",
          "form",
          "creator",
        ],
        grammarFocus:
            "ASL literary work uses linguistic and visual resources whose organization must be studied in the original signed performance, not only an English summary.",
        cultureFocus:
            "Learn from Deaf creators, respect rights, and distinguish studying craft from reproducing another artist’s work.",
        receptiveTask:
            "View an authorized ASL literary work and identify one craft choice supported by a specific passage.",
        expressiveTask:
            "Offer an attributed response to the work using learned language and a clearly identified example.",
        scenario:
            "A study group discusses how an ASL performer develops a recurring visual motif.",
        partnerA:
            "You noticed the motif in the opening and want to compare its later use.",
        partnerB:
            "You noticed a changed use near the ending and can point to that passage.",
        transferTwist:
            "An English summary omits the visual pattern you are discussing.",
        conceptQuestion:
            "What is necessary for analysis of a signed literary feature?",
        conceptAnswers: [
          "Evidence from the original authorized signed work and appropriate attribution.",
          "Only an English plot summary, regardless of the feature being analyzed.",
          "Assuming every visual pattern has the same meaning in every performance.",
        ],
        rubric: [
          "Identifies a specific craft feature",
          "Supports interpretation with a passage",
          "Credits the creator and respects usage rights",
        ],
        prerequisiteIds: ["register-and-audience"],
        referenceUrls: [
          "https://gallaudet.edu/asl-315-asl-literature-poetry-3/",
          "https://gallaudet.edu/deaf-studies/deaf-studies-digital-journal/publishing-asl-poems/",
        ],
      ),
      ProgramUnitBlueprint(
        id: "literary-analysis",
        title: "Read the performance closely",
        objectives: [
          "Compare interpretations with evidence",
          "Distinguish description from interpretation",
        ],
        vocabulary: [
          "motif",
          "perspective",
          "structure",
          "interpretation",
          "evidence",
          "comparison",
        ],
        grammarFocus:
            "Analytical discourse separates what a performance visibly does from an interpretation of its effect or significance.",
        cultureFocus:
            "A learner’s interpretation should remain open to creator context, community expertise, and alternative readings.",
        receptiveTask:
            "Compare two authorized passages and identify evidence for a proposed structural or perspective contrast.",
        expressiveTask:
            "Present an interpretation, cite a passage, and respond to a different plausible reading.",
        scenario:
            "Two viewers disagree about whether a repeated passage creates anticipation or reflection.",
        partnerA:
            "You interpret anticipation and can identify the timing and placement that support it.",
        partnerB:
            "You interpret reflection and can identify a later perspective that supports your reading.",
        transferTwist:
            "The creator’s commentary adds context neither viewer had considered.",
        conceptQuestion:
            "How should two plausible interpretations be compared?",
        conceptAnswers: [
          "Examine their supporting passages and context rather than treating preference as proof.",
          "Choose the interpretation stated by the faster signer.",
          "Assume any interpretation is equally supported without looking at the work.",
        ],
        rubric: [
          "Separates observation and interpretation",
          "Supports a reading with evidence",
          "Revises understanding when context changes",
        ],
        prerequisiteIds: ["art-and-expression"],
        referenceUrls: [
          "https://gallaudet.edu/asl-315-asl-literature-poetry-3/",
          "https://gallaudet.edu/deaf-studies/deaf-studies-digital-journal/publishing-asl-poems/",
        ],
      ),
      ProgramUnitBlueprint(
        id: "ethical-storytelling",
        title: "Tell a story responsibly",
        objectives: [
          "Distinguish ownership attribution and consent",
          "Preserve a person’s perspective in retelling",
        ],
        vocabulary: [
          "consent",
          "attribution",
          "perspective",
          "privacy",
          "adaptation",
          "responsibility",
        ],
        grammarFocus:
            "A retelling should preserve whose perspective is represented and distinguish direct quotation, paraphrase, and fictional adaptation.",
        cultureFocus:
            "Do not share identifiable personal experiences or recordings without appropriate consent; permission for one use is not unlimited permission.",
        receptiveTask:
            "Compare approved retellings and identify where attribution or perspective becomes ambiguous.",
        expressiveTask:
            "Tell an original or permitted story and make its source, scope, and perspective clear.",
        scenario:
            "A friend permits you to discuss a learning experience in a small class but not to post their video publicly.",
        partnerA:
            "You want to share a reflection and must stay within the friend’s stated permission.",
        partnerB:
            "You are the friend; clarify which details and uses are acceptable.",
        transferTwist:
            "A group member asks to upload the classroom recording to a public channel.",
        conceptQuestion:
            "What does permission to discuss a story in one class establish?",
        conceptAnswers: [
          "Permission for that agreed use, with other uses requiring their own appropriate consent.",
          "Unlimited permission to publish the person’s video and details.",
          "Permission to change the person’s perspective while presenting it as their account.",
        ],
        rubric: [
          "States source and perspective clearly",
          "Respects the agreed scope of use",
          "Distinguishes adaptation from another person’s account",
        ],
        prerequisiteIds: ["literary-analysis"],
        referenceUrls: [
          "https://www.nad.org/resources/american-sign-language/community-and-culture-frequently-asked-questions/",
          "https://nad.org/who-we-are/our-language/",
        ],
      ),
      ProgramUnitBlueprint(
        id: "sustained-unscripted-dialogue",
        title: "Beyond the prepared response",
        objectives: [
          "Maintain an extended spontaneous exchange",
          "Repair complex misunderstandings flexibly",
        ],
        vocabulary: [
          "elaboration",
          "spontaneous",
          "clarify",
          "rephrase",
          "topic",
          "follow-up",
        ],
        grammarFocus:
            "Sustained interaction draws on comprehension, grammatical control, elaboration, discourse management, and flexible repair across unfamiliar turns.",
        cultureFocus:
            "Work with consenting fluent partners and qualified reviewers; a conversational relationship is not an automatic assessment arrangement.",
        receptiveTask:
            "Follow extended authorized exchanges with unfamiliar signers and identify where meaning is negotiated.",
        expressiveTask:
            "Discuss a familiar and a less familiar topic with a fluent partner who asks unplanned follow-ups.",
        scenario:
            "A practice partner asks how a project changed your opinion, then challenges one assumption.",
        partnerA:
            "You explain your project and stay responsive rather than returning to a memorized monologue.",
        partnerB:
            "You ask an unexpected but relevant follow-up and request a rephrase if needed.",
        transferTwist:
            "The partner introduces a new example that partly contradicts your explanation.",
        conceptQuestion:
            "What demonstrates flexible conversation beyond a prepared script?",
        conceptAnswers: [
          "Meaningful comprehension and adaptation to unplanned turns, including appropriate repair.",
          "Returning to the memorized passage whenever a new question appears.",
          "Avoiding clarification to maintain the appearance of uninterrupted fluency.",
        ],
        rubric: [
          "Responds to unplanned information",
          "Elaborates coherently across turns",
          "Repairs misunderstandings without abandoning the exchange",
        ],
        prerequisiteIds: ["ethical-storytelling"],
        referenceUrls: [
          "https://gallaudet.edu/american-sign-language-proficiency-interview-aslpi/aslpi-preparation/aslpi-proficiency-levels/",
          "https://www.rit.edu/ntid/slpi",
        ],
      ),
      ProgramUnitBlueprint(
        id: "domain-depth",
        title: "Depth in a domain",
        objectives: [
          "Develop precise language in a chosen field",
          "Explain specialist ideas to different audiences",
        ],
        vocabulary: [
          "domain",
          "terminology",
          "definition",
          "example",
          "audience",
          "limitation",
        ],
        grammarFocus:
            "Specialized discourse needs accurate concepts, contextual terminology, grammatical organization, and the ability to paraphrase when a term is unfamiliar.",
        cultureFocus:
            "Domain language learning does not confer professional competence, interpreting credentials, or permission to provide expert services.",
        receptiveTask:
            "Study authorized signed explanations from qualified people in a chosen domain and identify their definitions and examples.",
        expressiveTask:
            "Explain a concept you genuinely understand to a fluent non-specialist, then to an informed partner.",
        scenario:
            "You explain a hobby process, such as seed storage, without assuming everyone knows its technical terms.",
        partnerA:
            "You understand the process and must define one specialist concept in accessible language.",
        partnerB:
            "You are a fluent non-specialist and ask for a concrete example of that concept.",
        transferTwist:
            "A term has different meanings in two communities or professional contexts.",
        conceptQuestion:
            "What should happen when a specialist term is unfamiliar?",
        conceptAnswers: [
          "Clarify its meaning in context and use a relevant definition or example.",
          "Assume fluent general ASL guarantees shared knowledge of every technical term.",
          "Invent an authoritative sign without checking domain usage.",
        ],
        rubric: [
          "Uses accurate domain concepts",
          "Explains unfamiliar terminology accessibly",
          "Identifies the limits of language and professional expertise",
        ],
        prerequisiteIds: ["sustained-unscripted-dialogue"],
        referenceUrls: [
          "https://gallaudet.edu/american-sign-language-proficiency-interview-aslpi/aslpi-preparation/aslpi-proficiency-levels/",
          "https://www.rit.edu/ntid/slpi",
        ],
      ),
      ProgramUnitBlueprint(
        id: "your-next-chapter",
        title: "Your next chapter",
        objectives: [
          "Assemble varied evidence of communication",
          "Set a reviewed plan for continued development",
        ],
        vocabulary: [
          "portfolio",
          "assessment",
          "strengths",
          "evidence",
          "goals",
          "community",
        ],
        grammarFocus:
            "Broad proficiency requires performance across receptive, expressive, and interactive tasks; no single script, vocabulary total, or lesson count establishes it.",
        cultureFocus:
            "Long-term growth includes authentic relationships, Deaf-led learning, and independently appropriate assessment; course completion is not interpreter qualification.",
        receptiveTask:
            "Review varied consented samples with a qualified person and identify strengths and recurring comprehension gaps.",
        expressiveTask:
            "Complete a narrative, explanation, and unscripted interaction, then define the next goals with a qualified reviewer.",
        scenario:
            "You present a portfolio containing a revised narrative, a domain explanation, and a spontaneous conversation.",
        partnerA:
            "You identify one strength and one uncertainty, linking each to a specific sample.",
        partnerB:
            "You are the qualified reviewer; request an additional task where the evidence is incomplete.",
        transferTwist:
            "The learner performs well on a familiar topic but struggles with an unfamiliar signer.",
        conceptQuestion: "What should a final program milestone establish?",
        conceptAnswers: [
          "A documented body of task-specific evidence and a next learning plan, without automatically certifying fluency.",
          "Expert proficiency solely because every activity is marked complete.",
          "Professional interpreting qualification from a successful solo recording.",
        ],
        rubric: [
          "Presents varied authentic evidence",
          "Distinguishes participation from assessed performance",
          "Sets specific next goals with qualified feedback",
        ],
        prerequisiteIds: ["domain-depth"],
        referenceUrls: [
          "https://gallaudet.edu/american-sign-language-proficiency-interview-aslpi/aslpi-preparation/aslpi-proficiency-levels/",
          "https://www.rit.edu/ntid/slpi",
        ],
      ),
    ],
  ),
];
