editable('samp_reward_dur', 'fix_window_radius', 'pre_fix_time', 'sample_time','delay_time','test1_match_time','test1_nonmatch_time','test1_nonmatch_rand','delay2_time','test2_time','num_rewards','reward_dur', 'iti_dur', 'ind');

wait_for_touch = 8000;
wait_for_fix = 8000;
fix_window_radius = 2;
pre_fix_time = 500;
sample_time = 600;
loccue_time = 600;
delay_time = 800;
test1_match_time = 500;
test1_nonmatch_time = 500;
test1_nonmatch_rand = 300;
delay2_time = 175;        %Changed from 75 on 8/17/2012
test2_time = 1000;
initial_fast_RT_window = 75;
num_rewards = 1;
reward_dur = 140;
samp_reward_dur = 0;
iti_dur = 2000;
ind = 0;
present_x = 0;
present_y = 0;
match_x = 3;
match_y = 0;
jitter_x = .5;
jitter_y = .5;
len_x = 3;
len_y = 3;

%% codes and objects
bar_down = 7;
bar_up = 4;
fixation_on = 35;
fixation_off = 36;
fixation_acq = 8;
sample_on = 23;
sample_off = 24;
test_on = 25;
test_off = 26;
final_on = 27;
final_off = 28;
loc_cue_on = 182;
loc_cue_off = 183;
reward_given = 96;

loc_cue = 2;
fix_dot = 1;
img_1 = 3;

% errors 
correct = 0;
no_response = 1;
early_response = 5;
no_fix = 4;
broke_fix = 3;

poss_xs = match_x + jitter_x*(-len_x:len_x);
poss_ys = match_y + jitter_y*(-len_y:len_y);

%% get condition
cond = TrialRecord.CurrentCondition;

% choose location
use_x = randsample(1:length(poss_xs), 1);
use_y = randsample(1:length(poss_ys), 1);

xloc = poss_xs(use_x);
yloc = poss_ys(use_y);

% choose non-match location
if cond == 2 || cond == 4
    xcands = 1:length(poss_xs);
    ycands = 1:length(poss_ys);
    xcands(use_x) = [];
    ycands(use_y) = [];
    use_nonx = randsample(xcands, 1);
    use_nony = randsample(ycands, 1);
    non_xloc = poss_xs(use_nonx);
    non_yloc = poss_ys(use_nony);
    test_time = ceil(test1_nonmatch_rand*rand())+ ...
        test1_nonmatch_time;
    match = 0;
    img_2 = img_1;
else
    non_xloc = xloc;
    non_yloc = yloc;
    test_time = test1_match_time;
    match = 1;
    img_2 = 4;
end

[ontarget, rt] = eyejoytrack('acquiretouch', [1], [3.0], wait_for_touch);
if ~ontarget,
    trialerror(no_response); %no touch
    rt=NaN;
    return
end
eventmarker(bar_down);  % bar down (hold)

toggleobject(1,'eventmarker',fixation_on); %fixation spot on

[ontarget, rt] = eyejoytrack('holdtouch', [1], [3.0], 'acquirefix', [1], [fix_window_radius], wait_for_fix);

if ~ontarget(1) % if lever break 
    trialerror(early_response); %lever break ->>> EARLY RESPONSE? WAS 2
    eventmarker(bar_up); %bar up (release)
    rt=NaN;
    toggleobject(1,'eventmarker',fixation_off); % turn off fixation spot
    return
elseif ~ontarget(2) 
    trialerror(no_fix); %no fixation
    rt=NaN;
    toggleobject(1,'eventmarker',fixation_off); % turn off fixation spot
    return
end
eventmarker(fixation_acq); %fixation occurs

[ontarget, rt] = eyejoytrack('holdtouch', [1], [3.0], 'holdfix', [1], [fix_window_radius], pre_fix_time);

if ~ontarget(1) % if lever break 
    trialerror(early_response); %lever break ->>> EARLY RESPONSE? WAS 2
    eventmarker(bar_up); %bar up (release)
    rt=NaN;
    toggleobject(1,'eventmarker',fixation_off); % turn off fixation spot
    return
elseif ~ontarget(2) 
    trialerror(no_fix); %no fixation
    rt=NaN;
    toggleobject(1,'eventmarker',fixation_off); % turn off fixation spot
    return
end

reposition_object(img_1, present_x, present_y);
reposition_object(loc_cue, xloc, yloc);
toggleobject(img_1,'eventmarker',sample_on); % turn on sample stim
toggleobject(loc_cue, 'eventmarker', loc_cue_on);
[ontarget, rt] = eyejoytrack('holdtouch', [1], [3.0], 'holdfix', ...
                             [1], [fix_window_radius], ...
                             sample_time);
if ~ontarget(1) % if lever break 
    trialerror(early_response); %lever break ->>> EARLY RESPONSE? WAS 2
    eventmarker(bar_up); %bar up (release)
    rt=NaN;
    toggleobject(1,'eventmarker',fixation_off); % turn off fixation
                                                % spot
    toggleobject(img_1,'eventmarker',sample_off); % turn off sample stim
    toggleobject(loc_cue, 'eventmarker', loc_cue_off);
    return
elseif ~ontarget(2) 
    trialerror(no_fix); %no fixation
    rt=NaN;
    toggleobject(1,'eventmarker',fixation_off); % turn off fixation
                                                % spot
    toggleobject(img_1,'eventmarker',sample_off); % turn off sample stim
    toggleobject(loc_cue, 'eventmarker', loc_cue_off);
    return
end

toggleobject(img_1,'eventmarker',sample_off); % turn off sample stim
toggleobject(loc_cue, 'eventmarker', loc_cue_off);
[ontarget, rt] = eyejoytrack('holdtouch', [1], [3.0], 'holdfix', ...
                             [1], [fix_window_radius], ...
                             delay_time);
if ~ontarget(1) % if lever break 
    trialerror(early_response); %lever break ->>> EARLY RESPONSE? WAS 2
    eventmarker(bar_up); %bar up (release)
    rt=NaN;
    toggleobject(1,'eventmarker',fixation_off); % turn off fixation spot
    return
elseif ~ontarget(2) 
    trialerror(no_fix); %no fixation
    rt=NaN;
    toggleobject(1,'eventmarker',fixation_off); % turn off fixation spot
    return
end

reposition_object(img_2, non_xloc, non_yloc);
toggleobject(img_2,'eventmarker', test_on); 
[ontarget, rt] = eyejoytrack('holdtouch', [1], [3.0], 'holdfix', ...
                             [1], [fix_window_radius], ...
                             test_time);
toggleobject(img_2,'eventmarker', test_off); % turn off
                                             % sample stim
if match
    toggleobject(1,'eventmarker',fixation_off); % turn off
                                                % fixation spot
    if ~ontarget(1) % if lever break 
        trialerror(correct); %lever break ->>> EARLY RESPONSE? WAS 2
        eventmarker(bar_up); %bar up (release)
        rt=NaN;
        eventmarker(reward_given);
        goodmonkey(reward_dur);
        return
    else
        trialerror(no_response);
        return
    end
else
    [ontarget, rt] = eyejoytrack('holdtouch', [1], [3.0], 'holdfix', ...
                                 [1], [fix_window_radius], ...
                                 delay2_time);
    if ~ontarget(1) % if lever break 
        trialerror(early_response); %lever break ->>> EARLY RESPONSE? WAS 2
        eventmarker(bar_up); %bar up (release)
        rt=NaN;
        toggleobject(1,'eventmarker',fixation_off); % turn off fixation spot
        return
    elseif ~ontarget(2) 
        trialerror(broke_fix); %no fixation
        rt=NaN;
        toggleobject(1,'eventmarker',fixation_off); % turn off fixation spot
        return
    end

    reposition_object(img_1, xloc, yloc);
    toggleobject(img_1, 'eventmarker', final_on);
    [ontarget, rt] = eyejoytrack('holdtouch', [1], [3.0], 'holdfix', ...
                                 [1], [fix_window_radius], ...
                                 test2_time);
    toggleobject(img_1,'eventmarker', final_off); % turn off
    toggleobject(1,'eventmarker',fixation_off); % turn off
                                                % fixation spot
    if ~ontarget(1) % if lever break 
        trialerror(correct); 
        eventmarker(bar_up); %bar up (release)
        rt=NaN;
        eventmarker(reward_given);
        goodmonkey(reward_dur);
        return
    else
        trialerror(no_response);
        return
    end
end