# Experiment Documentation


## Study/experiment information

### Research question:

Intertemporal choices, choices between small immediate rewards or larger, postponed rewards, are presented in many daily life situations. They have broad effects on maladaptive behaviors, such as pathological gambling. Because of the rising prevalence and severity of this problem, understanding the link between gambling and steep delay discounting is of utmost importance and could be helpful in the treatment of pathological gambling. In order to understand the link, this study aims to answer the following question: ‘What is the effect of wins and losses on intertemporal choices?’ An experiment will be conducted where participants can win or lose cents in gamble trials and are presented with an intertemporal choice afterwards.

### Experiment context:

-	Code: Gambling_ITC
-	Who: Zhang Chen & Ymke Verduyn
-	Where: online study via the Sona system of UGent
-	Credit/paid: Credit
-	When: February 2022

### Brief description of method (provide all info required to understand the headers):

Participants first receive the main task, in which they alternate between a guessing game and an intertemporal choice. Participants first press the space bar to initiate a guessing game. The guessing game has two types of trials: (1) gamble trials, in which participants guess whether the back side of a card is blue or yellow, by pressing either F or J. If they guess correctly, they win 20 cents; if they guess incorrectly, they lose 15 cents. (2) non-gamble trials, in which either a blue or a yellow card is shown. The task for the participants is to indicate the color of the card, again by pressing either F or J. They do not win or lose points in these non-gamble trials.

After the guessing game, participants press the space bar to continue to an intertemporal choice trial. They are presented with two options, an immediate option and a delay option. The delay option is always 20 cents, and participants need to wait for either 5 or 10 seconds. When the delay duration is 5 seconds, the immediate amount varies from 1 to 16 cents across trials; when the delay duration is 10 seconds, the immediate amount varies from 1 to 8 cents across trials. If participants choose the immediate option, the corresponding amount is immediately shown; if participants choose the delayed option, they need to wait till the delay duration passes. When the reward appears, participants need to press K to collect it. They then press space to initiate a guessing trial. Participants receive 6 blocks in total, with each block lasting 8 minutes. In other words, we use a design of fixed duration, rather than a fixed number of trials.

Participants then fill in the monetary choice questionnaire where they have to make 27 decisions between a smaller immediate amount of money or a larger but delayed amount of money. They can indicate which reward they would prefer by using the computer mouse or the touchpad.

In the last task, participants rate their emotions using the Self-Assessment Manikin (SAM). They need to indicate how they felt when they lost or won money in the guessing game. They need to select the manikin that most accurately represented their feeling by pressing the corresponding key. (D/F/G/H/J).

### Apparatus and calibration:

- Apparatus: PC, jsPsych
- Calibration protocol: None

### Data file information:

File Types: Behavioural data files only (CSV).

### Variable labels (headers) and variable coding:

#### Data from the main task (Gambling_ITC_main_X.csv)

- subject_ID = subject ID of participants.
- age = age of participant.
- gender = gender of participant. Four levels: male, female, non-binary, or I don't want to say
- nationality = self-reported nationality of participant.
- block_number = block number, from 1 to 6
- trial_number = trial number, depending on how many trials participants finish in total. Each trial consists of two parts, a guessing game and an intertemporal choice.
- trial_type = guess for the guessing game, or ITC for the intertemporal choice part.
- guess_outcome = outcome in the guessing game, loss, win or neutral.
- delay_time = the delay duration for the delayed option in the ITC, 5 seconds or 10 seconds.
- delay_pos = on which side the delayed option is presented, left or right.
- immediate_amount = the monetary amount for the immediate option, in cents.
- stage = one trial consists of 8 stages, namely (1) starting a guessing game, (2) making a choice in a guessing game, (3) getting the outcome of a guessing game, (4) starting a ITC trial, (5) making a choice in an ITC trial, (6) waiting for the reward in an ITC trial, (7) collecting the reward in an ITC trial, and (8) get the outcome in an ITC trial.
- respRT = the response time of each response, in milliseconds. Note that in some stages participants do not need to respond. The respRT will be 0 in such cases.
- respKey = which key is pressed. When no key press is required, this variable will be 'undefined'.
- blur_count = how often participants leave the experiment window.
- focus_count = how often participants enter the experiment window.
- total_points = the total number of points accumulated so far.
- remaining_duration = the remaining duration in the current block, in milliseconds.
- time_elapsed = time elapsed since the beginning of the experiment, in milliseconds.

#### Data from the Monetary Choice Questionnaire (Gambling_ITC_MCQ_X.csv)

- subject_ID = subject ID of participants.
- task = number of the current task, MCQ.
- number = question number, from 1 to 27.
- now = the immediate option.
- delayed = the delayed option.
- selected = the selected option.
- choice = which participants select the 'now' or the 'wait' option.
- rt = response time of making a choice, in milliseconds.
- time_elapsed = time elapsed since the beginning of the experiment, in milliseconds.

#### Data from the Self-Assessment Manikin (Gambling_ITC_SAM_X.csv)

- subject_ID = subject ID of participants.
- task = task name, SAM.
-	outcome = whether the question is about win or about loss.
- question = whether the question is about valence, arousal or control.
- resp = the answer participant gives to a certain item.
- rt = reaction time since the presentation of the item till the submission of a response, in milliseconds.


#### Data the payoff (Gambling_ITC_payoff_X.csv)

- subject_ID = subject ID of participants.
- question = block number, 1 to 6.
- answer = how many cents participants win in each block.


### Quality control measures
None.

### Additional documents
None.
