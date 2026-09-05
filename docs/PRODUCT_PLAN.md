# nohasl product plan

**Product direction:** a beautiful, camera-centered ASL learning studio that helps learners build practical comprehension and expressive skill, from their first visual conversation to advanced, spontaneous communication. Web, macOS, and iOS are the initial supported experiences. Android and Windows share the Flutter codebase and follow after platform-specific camera and accessibility validation.

**Status:** this repository begins with an interactive application foundation. The curriculum is an editorial proposal awaiting Deaf ASL educator review. Camera practice is self-guided. The app does not yet contain a licensed, educator-verified signer-video curriculum, automated sign assessment, live tutoring, or a validated fluency assessment. Completing an activity is a practice record, not evidence that a sign was correct or that the learner is fluent.

## Principles that determine the product

1. **ASL is the language of the experience.** Teach meaning, visual attention, spatial relationships, facial grammar, and discourse together. English text is a scaffold that can be reduced as a learner develops; word-for-word English conversion is not the learning model. ASL has its own grammar, and nonmanual signals contribute to meaning. See [ASL University's grammar introduction](https://www.lifeprint.com/asl101/topics/excerptgrammar.htm) and [nonmanual markers](https://www.lifeprint.com/asl101/topics/sentencetypes.htm).
2. **Deaf people shape the curriculum.** Pay Deaf educators, native signers, cultural reviewers, and accessibility testers. Give reviewers authority to reject incorrect demonstrations, exercises, or feedback. Include variation instead of presenting one signer's production as the only valid form; [the NAD explains regional differences in ASL](https://nad.org/knowledge-hub/american-sign-language/learning-american-sign-language/).
3. **Practice begins immediately.** Every instructional unit contains expressive and receptive work. A learner observes a meaningful exchange, notices one feature, tries it, reflects, and uses it in a new context.
4. **Trust is part of quality.** Camera preview, tracking visibility, recognition confidence, and language proficiency are separate concepts. Show their actual state. Abstain when the model cannot assess an attempt. Never manufacture a hand skeleton, accuracy percentage, or “correct” result for decorative effect.
5. **Audio is optional support.** Narration, cues, and optional sound effects complement captions, visual pacing, and haptics. No learning objective or navigation task depends on hearing. ASL demonstrations remain visual, including facial expression and upper-body movement.
6. **Motivation comes from meaningful progress.** Story discoveries, increasing conversational agency, clear goals, and evidence of retained skills should sustain practice. Streaks have recovery options; camera refusal and accessibility accommodations never incur a penalty.
7. **Fluency grows through people.** Advanced work includes spontaneous interaction, different signers, cultural participation, and educator feedback. No fixed lesson count, streak, or AI score guarantees fluency. This learning program does not confer interpreter qualifications.

## Delivery boundary

| Area | Initial application foundation | Required before a learning release |
|---|---|---|
| Experience | Responsive Flutter learning dashboard, curriculum navigation, practice studio, stories, library, and personal progress | Usability studies with new signers and Deaf reviewers; accessible interaction across input modes |
| Lessons | Structured sample objectives, explanations, prompts, reflection, and knowledge checks | Reviewed instructional scripts, valid distractors, licensed signer demonstrations, pilot learning evaluation |
| Camera | User-initiated local live preview and guided self-review with honest unavailable/permission states | Device camera matrix, framing assistance, verified mirroring/orientation, lifecycle and permission testing |
| Assessment | Knowledge-check answers and learner-reported practice/completion | Separated receptive/expressive rubrics, delayed checks, educator validation and calibrated limited-scope models |
| Stories | Interactive text/illustrated scenes and branches as an experience prototype | Deaf-authored signed scenes, meaningful ASL comprehension branches, expressive response opportunities |
| Content | Proposed multilevel sequence and a browsable sample vocabulary catalog | Editorial CMS, reviewer approvals, regional metadata, media rights, release versioning |
| Persistence | Local preferences, completion, and saved content | Versioned migrations, export/delete controls, optional account sync and conflict handling |
| Platforms | Flutter targets for web, macOS, iOS, Android, and Windows | Release-specific build, runtime, accessibility, performance, and hardware camera gates |

Illustrations establish visual character and explain concepts. They are not authoritative sign demonstrations. A stylized hand image or generic motion path must not be presented as a reliable lesson in producing a sign.

## The learner journey

### First visit: accomplish something without setup friction

- Choose a practical motivation: family and friends, community, everyday conversation, school, or work.
- Choose a comfortable daily goal and optional accessibility preferences. Do not ask for an account before the first meaningful activity.
- Establish the distinction between watching, practicing, and being assessed. Explain local camera use before requesting permission.
- Start with visual attention and a tiny, reviewed exchange. Offer side-by-side camera practice, a camera-free alternative, and a short reflection.
- End with a clear next action, a saved practice record, and a preview of the first story. Place returning learners through receptive and expressive tasks once reviewed assessment exists.

### The repeatable session: 8–15 minutes, adjustable

1. **Reconnect:** one due retrieval item and a short context from the ongoing story.
2. **Watch:** a Deaf signer uses a new feature in a meaningful exchange; replay or slow down while preserving visible movement.
3. **Notice:** focus on one contrast, such as a change in location or a grammatical facial signal.
4. **Try:** sign with a camera or in a camera-free mode; receive one specific next step rather than a wall of feedback.
5. **Transfer:** use the feature with a new partner, referent, situation, or branch in a story.
6. **Retrieve:** attempt without the model before checking it again.
7. **Reflect:** identify what felt easy or uncertain, schedule review, and show the next achievable milestone.

This sequence is a product hypothesis. Pilot sessions should test whether it supports learning and enjoyable repeat use before scaling content production.

## Curriculum design

The proposed levels are internal product stages, not certified proficiency classifications. Educators must finalize sequence, regional coverage, appropriate examples, and advancement rubrics. Each unit bundles receptive comprehension, expressive production, grammar, cultural context, and a transfer task; vocabulary counts are content-planning targets rather than a proxy for fluency.

| Stage | Communication outcomes | Language and cultural focus | Milestone evidence |
|---|---|---|---|
| 1 · First connections | Begin a visual interaction; introduce oneself; request repetition and clarification | Attention and turn-taking; visual signing space; dominant hand; introductory fingerspelling and numbers; handshape, orientation, location, movement, and nonmanual features | Understand several unfamiliar introductions; perform a short exchange and repair a misunderstanding |
| 2 · Everyday life | Discuss routines, relationships, preferences, time, and immediate needs | Questions, negation, references in space, time expression, basic sentence patterns; appropriate interaction in everyday Deaf spaces | Complete a practical information gap with an unfamiliar signer and a short unscripted exchange |
| 3 · Connecting ideas | Describe places and people; make plans; recount simple events | Spatial reference, directional relationships, descriptive and depicting constructions, sequencing, increasing fingerspelling fluency | Give directions, interpret a partner's description, and recount a connected personal event |
| 4 · Stories in motion | Tell coherent narratives; compare experiences; express viewpoint | Role shift, constructed action/dialogue, referent tracking, viewpoint, aspect, discourse transitions and nonmanual timing | Retell unfamiliar signed content, sustain referents, and respond to follow-up questions |
| 5 · In the community | Explain an opinion, resolve ambiguity, discuss abstract and specialized topics | Register, pragmatic inference, idiomatic usage, regional and social variation, richer depicting constructions, cohesive extended discourse | Discuss unfamiliar material with multiple signers; adapt an explanation after misunderstanding |
| 6 · Beyond the familiar | Participate flexibly in spontaneous, sustained signed interaction | Rapid turn-taking, repair, varied signing styles, authentic signed media, narrative style, community participation, learner-selected domains | A reviewed portfolio and live interaction demonstrating comprehension, expression, repair, and adaptation across contexts |

Depicting/classifier work must be taught in context: a handshape alone does not establish the referenced entity or its meaning. See [ASL University's discussion of classifier constructions](https://www.lifeprint.com/asl101/pages-signs/classifiers/classifiers-main.htm).

### Proposed program size and dependencies

- Plan for **6 stages × 8 units × 6 lessons = 288 core lessons**, with short review activities, signed story episodes, and capstones alongside them. This is a production scope proposal; the current app contains **6 stages × 3 units × 3 lessons = 54 authored demonstration lessons**, pending educator review.
- Each unit has prerequisite skills, target skills, retrieval items, receptive and expressive variants, one cultural thread, one contextual transfer task, and an assessment rubric.
- Keep separate skill records for recognizing a concept, producing it, using its grammar in context, and transferring it to conversation. Strength in one does not automatically promote another.
- Allow learners to revisit any material. Recommend advancement using evidence and confidence, with optional educator placement; do not permanently lock useful material behind streaks or payment-triggering failure loops.
- Distribute fingerspelling, number comprehension, variation, visual attention, and repair across all stages. Avoid treating the alphabet as an adequate prerequisite for communicating.

## Practice modes with distinct purposes

| Mode | Learner activity | Useful feedback | Main dependency |
|---|---|---|---|
| Mirror studio | Observe a model and rehearse beside a live camera | Framing hints, replay, selected rubric, learner reflection | Reviewed video + camera preview |
| Recall cards | Produce from a concept or image, then reveal a signer | Recall confidence; optional restricted automatic feedback later | Reviewed sign variants + scheduling |
| Spot the difference | Compare two signed productions or match a clip to meaning | Explain the relevant contrast after answering | Valid minimal-pair media + educator review |
| Fingerspelling lab | Recognize letter sequences in context; produce names and words | Whole-word comprehension, pacing, targeted replay | Varied signers and speeds; temporal assessment later |
| Spatial scene builder | Watch a description, then place items; describe a scene back | Meaning-based scene comparison and spatial-reference rubric | Signed prompts + accessible scene controls |
| Conversation rehearsal | Reply to a filmed partner, clarify, and take a turn | Goal completion, repair strategy, educator exemplar | Scripted signed branches + response rubric |
| Story missions | Predict, investigate, choose, and retell through an unfolding narrative | Consequences grounded in understanding, with replay | Deaf-authored story media + branch authoring |
| Shadow and retell | Rehearse briefly, then reconstruct meaning independently | Coherence and retained meaning; avoid rewarding mimicry alone | Reviewed narratives + rubric |
| Partner challenges | Exchange information neither partner has alone | Mutual comprehension and reflective partner feedback | Consent, scheduling, moderation, reporting |
| Portfolio studio | Record a chosen response and compare it over time | Self-review, teacher annotations, future reassessment | Explicit recording consent + secure media handling |

Accessibility variants offer slower pacing, larger signing frames, one-handed navigation, keyboard controls, text scaffolds, and alternatives to timed tasks. Learners can adjust movement demands and opt out of automatic assessment. Do not assume a single standard body, range of motion, dominant hand, skin tone, or signing speed.

## Stories and conversation

The story system should create recurring characters and a reason to return: meeting a neighbor, helping organize a community event, following a small mystery, or planning a shared trip. Deaf writers and actors define believable circumstances, humor, relationships, and cultural context.

Each episode needs:

- A communicative objective, prerequisite skills, and content version.
- A filmed opening, meaningful choices, and a replay path that reveals missed context.
- At least one receptive task and one expressive response whose intention matters to the scene.
- Alternative valid ways to communicate, clarification requests, and recovery after misunderstanding.
- A short retelling or transfer prompt, plus later review of concepts used in the episode.

Begin with curated branches and teacher-reviewed responses. Later conversation AI can select reviewed clips, manage turns, and generate text scaffolds constrained by lesson intent. Unvalidated generated sign videos, synthetic avatars, and arbitrary machine translations must not become the source of instructional truth.

## Feedback and adaptive learning

**Initial feedback:** show the reviewed model, a small educator-authored observation rubric, an opportunity to try again, and a confidence reflection. Mark completion as self-reported practice. Knowledge-check scoring may judge the selected answer, not camera production.

**Later automatic feedback:** separate capture quality from recognized content and from a grammatical interpretation. Limit evaluation to supported tasks and variants, explain the specific observation, and offer “I couldn't assess this” when needed. A learner can dispute feedback and still complete the activity. Never penalize low light, unsupported hardware, or an inaccessible movement requirement as a language error.

**Review scheduler:** collect the attempted skill, assessment type, outcome source, elapsed time, item version, prior exposure, and confidence. Use simple transparent intervals initially; evaluate an adaptive scheduling algorithm against delayed recall before adopting it. Separate receptive and expressive evidence. Mix due reviews with new material, varied signers, contextual use, and rest. Enforce a daily workload ceiling and let the learner reschedule.

**Progress:** show practice time, completed activities, review due, and a skills map with evidence labels. Distinguish “practiced,” “recalled,” “used in context,” and “reviewed by an educator.” Award celebrations for effort and meaningful milestones, not unsupported proficiency percentages.

In the initial implementation, XP is awarded once per unique completed lesson. Activity minutes use actual elapsed lesson time, rounded down per completion, rather than the lesson's advertised duration. An attempt lasting less than 60 seconds adds no activity minutes and does not establish an activity day or streak. Repeating a lesson can add time, but not another first-completion XP award. These measures describe participation only.

## Content production and governance

1. A Deaf curriculum lead defines the communicative objective, concepts, grammar, cultural context, regional scope, acceptable variants, and accessibility options.
2. A writer creates a short script and exercise set; an independent ASL educator checks meaning and teaching sequence before filming.
3. Contract and compensate diverse Deaf signers with explicit instructional-media rights. Model-training permission is a separate, optional agreement.
4. Film full face, torso, and signing space in consistent light; capture natural-speed demonstrations, useful alternate views, and contextual exchanges. Preserve meaningful movement and facial detail when editing.
5. Annotate concept IDs, region/register, signer, dominant hand, temporal boundaries, grammar features, translation/scaffolding, captions, and exercise rubrics. English gloss is an annotation aid, not a substitute for the ASL video.
6. Run linguistic review, cultural review, rights verification, accessible playback review, and technical checks. Publish only approved content versions; maintain a correction history and withdrawal path.
7. Pilot with learners and educators. Track confusing prompts, accepted variants incorrectly rejected, comprehension transfer, and accessibility issues. Revise content independently of app releases.

**Release gate:** all instructional demonstrations and answer explanations in a learning release must have recorded educator approval and media rights. No scraped dictionary videos or unlicensed tutorial recordings are bundled by default.

## Camera and recognition roadmap

1. **Self-review:** local preview, intentional start/stop, framing guide, explicit permission recovery, and lifecycle cleanup. Learner marks an attempt; the app does not evaluate its correctness.
2. **Capture-quality assistance:** detect whether required hands, face, and upper body are visible. Warn about occlusion or insufficient light without pretending this measures ASL skill.
3. **Constrained production coaching:** a validated temporal model for a small approved vocabulary and specific exercises. Use hands, face, upper-body pose, and motion; static handshape classification cannot cover the curriculum.
4. **Phrase and grammar coaching:** evaluate scoped nonmanual timing, reference consistency, and meaningful distinctions, with independent educator review of both correct and incorrect feedback.
5. **Conversation support:** understand learner intent within supported contexts, permit repair, and defer uncertain/open-ended judgments to the learner or educator.

Before moving between stages, evaluate unseen signers, unseen sessions, clothing/background changes, left/right dominance, signing speeds, skin tones, lighting, occlusion, camera positions, regional variation, and relevant mobility differences. Report abstention rates and false-correction rates as well as accuracy. Use signer-disjoint datasets and a held-out external evaluation; avoid splitting neighboring frames of the same person between training and test.

Landmark tools can supply hand positions and handedness; they do not themselves assess ASL correctness. The proposed perception layer may use [MediaPipe Hand Landmarker](https://ai.google.dev/edge/mediapipe/solutions/vision/hand_landmarker), combined with face/pose and a separately validated temporal language model.

## Privacy and operational expectations

- Start cameras only after a clear user action. Explain whether data stays local before permissions appear. Stop capture when leaving practice, stopping it, or putting the app into an inactive state.
- Default to on-device preview and processing. Recording, cloud feedback, instructor sharing, analytics involving video, and model-training contribution are separate opt-ins.
- Keep raw frames out of application logs, crash reports, and routine analytics. Treat landmarks as sensitive movement information too.
- Later saved recordings need visible retention, export, deletion, access control, and a clear indicator while recording. Deleting an account must address associated media and derived features.
- Scope the first beta to adult independent learners; a future child/family release requires its own consent, moderation, and retention design.
- Community features require reporting, blocking, moderator staffing, and participant consent before launch. Avoid recording remote partners by default.

## Delivery phases and acceptance gates

| Phase | Deliverable | Acceptance gate |
|---|---|---|
| 0 · Foundation | Premium responsive Flutter shell; seed lessons; story branches; library; local progress; honest live camera studio; CI | Static analysis and meaningful tests pass; web/macOS/iOS build evidence recorded; core flows run on macOS and iOS Simulator; no unsupported AI/proficiency claims |
| 1 · Reviewed beginner pilot | First 2 complete units, approximately 12 lessons, 1 signed story, reviewed signer media, accessible playback, controlled learner study | 100% published instructional media reviewed and licensed; all lessons include receptive and expressive work; learners complete target communication tasks with educator-observed evidence; physical iPhone and Mac camera paths pass |
| 2 · Learning alpha | Entire first stage; review scheduling; offline lesson packs; versioned content pipeline; optional account sync; capture-quality assistance | Reviewed curriculum coverage, delayed recall baseline, reliable sync/delete behavior, real-device performance and accessibility gates; capture assistance does not label sign correctness |
| 3 · Supported coaching beta | Scoped sign production model; educator feedback tools; stages 2–3; richer stories; Android/Windows camera support | Predeclared educator-approved evaluation thresholds met on external signer-disjoint data; low-confidence abstention and appeal work; platform feature-parity and permission tests pass |
| 4 · Conversation program | Stages 4–6, advanced receptive media, long-form narratives, partner practice, portfolios, scheduled instructor review | Advanced outcomes observed in unfamiliar tasks and live interaction; moderation operational; progression distinguishes practice evidence from independently assessed skill |
| 5 · General release and improvement | Reliable content cadence, signed distribution, production support, optional validated conversation assistance | Accessibility audit, privacy review, native store requirements, measured reliability, content correction SLA, external educator review, and a sustainable paid Deaf editorial program |

Do not schedule a broad recognition promise before data rights, model feasibility, and external evaluation are established. Content production and Deaf educator review are core delivery work, not launch polish.

## Success measures

The primary outcome is improvement in meaningful ASL comprehension and communication on unfamiliar tasks, observed by qualified educators. Product metrics supplement that evidence:

- Activation: first complete observe–try–reflect cycle; first successful communicative task.
- Learning: delayed receptive recall, expressive rubric improvement, repair success, transfer to unfamiliar signers and contexts.
- Engagement: voluntary return for learning, story continuation, comfortable session completion, sustainable weekly practice.
- Trust: feedback dispute and overturn rates, model abstention, learner understanding of what is assessed, content correction turnaround.
- Equity: outcome and error differences across supported devices and relevant learner groups, including rates of unsupported assessment.
- Reliability: crash-free sessions, camera-start success, permission recovery, media playback success, lost-progress incidents.

Set numerical targets after the beginner pilot establishes a baseline. Do not inflate retention with punitive streak mechanics or count a pressed “complete” button as measured language acquisition.

## Immediate execution backlog

1. Validate the foundation on macOS, iOS Simulator, and a browser; record actual commands and device limitations.
2. Recruit and compensate a Deaf curriculum lead and an independent reviewer; approve the first unit's scope.
3. Commission the initial media package and metadata schema; integrate accessible playback and reviewed captions.
4. Add physical iPhone/iPad and Mac camera tests for grant, denial, revocation, mirroring, rotation, interruption, backgrounding, and cleanup.
5. Implement reviewed observe–try–reflect lesson flow, per-skill evidence, and a simple review queue.
6. Run a small moderated pilot; revise confusing interactions and content before scaling the program.
7. Prototype capture-quality assistance using consented data and a supported-device benchmark; keep recognition behind a separate research gate.
