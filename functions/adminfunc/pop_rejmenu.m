% pop_rejmenu() - Main menu for rejecting trials in an EEG dataset
%
% Usage: >> pop_rejmenu(INEEG, typerej);
%
% Inputs:
%   INEEG      - input dataset
%   typerej    - type of rejection (0 = based on independent components; 
%                1 = based on raw data). Default is 1 (reject on raw data).
%
% Author: Arnaud Delorme, CNL / Salk Institute, 2001
%
% See also: eeglab(), pop_eegplot(), pop_eegthresh, pop_rejtrend()
% pop_rejkurt(), pop_jointprob(), pop_rejspec() 

%123456789012345678901234567890123456789012345678901234567890123456789012

% Copyright (C) 2001 Arnaud Delorme, Salk Institute, arno@salk.edu
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

% $Log: not supported by cvs2svn $
% 01-25-02 reformated help & license -ad 

function cb_compthresh = pop_rejmenu( EEG, typerej ); 

typerej=~typerej;
if typerej == 1
	if isempty( EEG.icasphere )
		disp('Error: you must first run ICA on the data'); return;
	end;
end;

if typerej == 0 	rejtitle = 'Reject trials using raw data statistics'; tagmenu = 'rejtrialraw';
else            	rejtitle = 'Reject trials using ICA data statistics'; tagmenu = 'rejtrialica';
end;	

if ~isempty( findobj('tag', tagmenu))
	error('cannot open two identical windows; close the first one first');
end;

figure('numbertitle', 'off', 'name', rejtitle, 'tag', tagmenu);

% definition of callbacks
% -----------------------
checkstatus = [ 'rejstatus = get( findobj(''parent'', gcbf, ''tag'', ''rejstatus''), ''value'');' ...
                'if rejstatus == 3,' ...
                '    EEG = eeg_rejsuperpose( EEG, ' int2str(typerej) ',' ...
                '    get( findobj(''parent'', gcbf, ''tag'', ''IManual''), ''value''),' ...
                '    get( findobj(''parent'', gcbf, ''tag'', ''IThresh''), ''value''),' ...
                '    get( findobj(''parent'', gcbf, ''tag'', ''IConst''), ''value''),' ...
                '    get( findobj(''parent'', gcbf, ''tag'', ''IEnt''), ''value''),' ...
                '    get( findobj(''parent'', gcbf, ''tag'', ''IKurt''), ''value''),' ...
                '    get( findobj(''parent'', gcbf, ''tag'', ''IFreq''), ''value''),' ...
                '    get( findobj(''parent'', gcbf, ''tag'', ''IOthertype''), ''value''));' ...
                'end;' ...
                'rejstatus = rejstatus-1;' ]; % from 1-3 range, go to 0-2 range

cb_manual = [ 	checkstatus ...
				'pop_eegplot( EEG, ' int2str( typerej ) ', rejstatus, 0);' ...
				'clear rejstatus;' ]; 

% -----------------------------------------------------

% tmp_com is used when returning from eegplot
tmp_com =       [ '  set(findobj(''''parent'''', findobj(''''tag'''', ''''' tagmenu '''''), ''''tag'''', ''''threshtrial''''), ''''string'''', num2str(sum(tmprej)));']; 
cb_compthresh = [ '  posthresh = get( findobj(''parent'', gcbf, ''tag'', ''threshpos''), ''string'' );' ...
                  '  negthresh = get( findobj(''parent'', gcbf, ''tag'', ''threshneg''), ''string'' );' ...
                  '  startime  = get( findobj(''parent'', gcbf, ''tag'', ''threshstart''), ''string'' );' ...
                  '  endtime   = get( findobj(''parent'', gcbf, ''tag'', ''threshend''), ''string'' );' ...
                  '  elecrange = get( findobj(''parent'', gcbf, ''tag'', ''threshelec''), ''string'' );' ...
                  checkstatus ...
				  '[Itmp LASTCOM] = pop_eegthresh( EEG,' int2str(typerej) ', elecrange, negthresh, posthresh, startime, endtime, rejstatus, 0,''' tmp_com ''');' ...
				  'h(LASTCOM);' ...
				  'clear com Itmp elecrange posthresh negthresh startime endtime rejstatus;' ];

%                  '  set(findobj(''parent'', gcbf, ''tag'', ''threshtrial''), ''string'', num2str(EEG.trials - length(Itmp)));' ...
%				  'h(LASTCOM);' ...
%				  'clear Itmp elecrange posthresh negthresh startime endtime rejstatus;' ];

% -----------------------------------------------------
tmp_com =       [ '  set(findobj(''''parent'''', findobj(''''tag'''', ''''' tagmenu '''''), ''''tag'''', ''''freqtrial''''), ''''string'''', num2str(sum(tmprej)));']; 
cb_compfreq   = [ '  posthresh = get( findobj(''parent'', gcbf, ''tag'', ''freqpos''), ''string'' );' ...
                  '  negthresh = get( findobj(''parent'', gcbf, ''tag'', ''freqneg''), ''string'' );' ...
                  '  startfreq = get( findobj(''parent'', gcbf, ''tag'', ''freqstart''), ''string'' );' ...
                  '  endfreq   = get( findobj(''parent'', gcbf, ''tag'', ''freqend''), ''string'' );' ...
                  '  elecrange = get( findobj(''parent'', gcbf, ''tag'', ''freqelec''), ''string'' );' ...
                  checkstatus ...
				  '[EEG Itmp LASTCOM] = pop_rejspec( EEG,' int2str(typerej) ', elecrange, negthresh, posthresh, startfreq, endfreq, rejstatus, 0,''' tmp_com ''');' ...
				  'h(LASTCOM);' ...
				  'clear Itmp elecrange posthresh negthresh startfreq endfreq rejstatus;' ];

% -----------------------------------------------------
tmp_com =         [ '  set(findobj(''''parent'''', findobj(''''tag'''', ''''' tagmenu '''''), ''''tag'''', ''''consttrial''''), ''''string'''', num2str(sum(tmprej)));']; 
cb_compconstrej = [ '  minslope   = get( findobj(''parent'', gcbf, ''tag'', ''constpnts''), ''string'' );' ...
					'  minstd    = get( findobj(''parent'', gcbf, ''tag'', ''conststd''), ''string'' );' ...
					'  elecrange = get( findobj(''parent'', gcbf, ''tag'', ''constelec''), ''string'' );' ...
                    checkstatus ...
				    '[rej LASTCOM] = pop_rejtrend(EEG,' int2str(typerej) ', elecrange, ''' int2str(EEG.pnts) ''', minslope, minstd, rejstatus, 0,''' tmp_com ''');' ...
				    'h(LASTCOM);' ...
				    'clear rej elecrange minslope minstd rejstatus;' ];

% -----------------------------------------------------
tmp_com =        [ '  set(findobj(''''parent'''', findobj(''''tag'''', ''''' tagmenu '''''), ''''tag'''', ''''enttrial''''), ''''string'''', num2str(sum(tmprej)));']; 
cb_compenthead = [ '  locthresh  = get( findobj(''parent'', gcbf, ''tag'', ''entloc''), ''string'' );', ...
				   '  globthresh = get( findobj(''parent'', gcbf, ''tag'', ''entglob''), ''string'' );', ...
				   '  elecrange  = get( findobj(''parent'', gcbf, ''tag'', ''entelec''), ''string'' );' ];
cb_compenttail = [ '  set( findobj(''parent'', gcbf, ''tag'', ''entloc''), ''string'', num2str(locthresh) );', ...
				   '  set( findobj(''parent'', gcbf, ''tag'', ''entglob''), ''string'', num2str(globthresh) );', ...
				   '  set( findobj(''parent'', gcbf, ''tag'', ''enttrial''), ''string'', num2str(nrej) );' ...
				   'h(LASTCOM);' ...
				   'clear nrej elecrange locthresh globthresh rejstatus;' ];
cb_compentplot =  [ cb_compenthead ...	
				    '[EEG locthresh globthresh nrej LASTCOM] = pop_jointprob( EEG, ' int2str(typerej) ', elecrange, locthresh, globthresh, 0, 0);', ...
				    cb_compenttail ];
cb_compentcalc =  [ cb_compenthead ...	
				    '[EEG locthresh globthresh nrej LASTCOM] = pop_jointprob( EEG, ' int2str(typerej) ', [ str2num(elecrange) ], str2num(locthresh), str2num(globthresh), 0, 0);', ...
 				    cb_compenttail ];
cb_compenteeg  =  [ cb_compenthead ...	
                    checkstatus ...
				    '[EEG locthresh globthresh nrej com] = pop_jointprob( EEG, ' int2str(typerej) ', elecrange, locthresh, globthresh, rejstatus, 0, 1,''' tmp_com ''');', ...
 				    cb_compenttail ];

% -----------------------------------------------------
tmp_com =        [ '  set(findobj(''''parent'''', findobj(''''tag'''', ''''' tagmenu '''''), ''''tag'''', ''''kurttrial''''), ''''string'''', num2str(sum(tmprej)));']; 
cb_compkurthead =[ '  locthresh  = get( findobj(''parent'', gcbf, ''tag'', ''kurtloc''), ''string'' );', ...
				   '  globthresh = get( findobj(''parent'', gcbf, ''tag'', ''kurtglob''), ''string'' );', ...
				   '  elecrange  = get( findobj(''parent'', gcbf, ''tag'', ''kurtelec''), ''string'' );' ];
cb_compkurttail =[ '  set( findobj(''parent'', gcbf, ''tag'', ''kurtloc''), ''string'', num2str(locthresh) );', ...
				   '  set( findobj(''parent'', gcbf, ''tag'', ''kurtglob''), ''string'', num2str(globthresh) );', ...
				   '  set( findobj(''parent'', gcbf, ''tag'', ''kurttrial''), ''string'', num2str(nrej) );' ...
				   'h(LASTCOM);' ...
				   'clear nrej elecrange locthresh globthresh rejstatus;' ];
cb_compkurtplot = [ cb_compkurthead ...	
				    '[EEG locthresh globthresh nrej LASTCOM] = pop_rejkurt( EEG, ' int2str(typerej) ', elecrange, locthresh, globthresh, 0, 0);', ...
				    cb_compkurttail ];
cb_compkurtcalc = [ cb_compkurthead ...	
				    '[EEG locthresh globthresh nrej LASTCOM] = pop_rejkurt( EEG, ' int2str(typerej) ', [ str2num(elecrange) ], str2num(locthresh), str2num(globthresh), 0, 0);', ...
 				    cb_compkurttail ];
cb_compkurteeg  = [ cb_compkurthead ...	
                    checkstatus ...
				    '[EEG locthresh globthresh nrej com] = pop_rejkurt( EEG, ' int2str(typerej) ', elecrange, locthresh, globthresh, rejstatus, 0, 1,''' tmp_com ''');', ...
 				    cb_compkurttail ];

% -----------------------------------------------------
cb_reject =      [ 'set( findobj(''parent'', gcbf, ''tag'', ''rejstatus''), ''value'', 3);' ... % force status to 3 
				    checkstatus ...
				   '[EEG com] = pop_rejepoch( EEG, EEG.reject.rejglobal, 1);' ...
				   'h(com);' ...
				   'eeg_store; eeg_updatemenu; close(gcbf);' ];

cb_clear =       [ 'close gcbf; EEG = rmfield( EEG, ''reject''); EEG.reject.rejmanual = []; EEG=eeg_checkset(EEG); pop_rejmenu(' inputname(1) ',' int2str(typerej) ');' ];   

lisboxoptions = { 'string', [ 'No superposition with previous trial rejection|' ...
                  'Superposition with trial rejection of the local measure|' ...
                  'Superposition with all rejections'], 'tag', 'rejstatus', 'value', 3, 'callback', ...
                  [ 'if get(gcbo, ''value'') == 3,' ...
                    '   set(findobj(''parent'', gcbf, ''style'', ''checkbox''), ''enable'', ''on'');' ...
                    'else' ...
                    '   set(findobj(''parent'', gcbf, ''style'', ''checkbox''), ''enable'', ''off'');' ...
                    'end;' ] };

allh = supergui( { 	[1 2 1] [1] ...
					[1] [0.25 1 1 1 1] [0.25 1 1 1 1] [0.25 1 1 1 1] [0.25 1 1 1 1] ...
					[1] [1] [0.25 1 1 1 1] [0.25 1 1 1 1] [0.25 1 1 1 1] ...
					[1] [1] [0.25 1 1 1 1] [0.25 1 1 1 1] [0.25 1 1 1 1] ...
					[1] [1] [0.25 1 1 1 1] [0.25 1 1 1 1] [0.25 1 1 1 1] ...
					[1] [1] [0.25 1 1 1 1] [0.25 1 1 1 1] [0.25 1 1 1 1] [0.25 1 1 1 1] ...
					[1] [1] [1] [1 1 1 1] [1 1 1 1]  ...
					[1] [1 1 1]}, ...
	{ }, { 'Style', 'pushbutton', 'string', 'Manual rejection', 'callback', cb_manual }, { },...
	{ },...
	...
	{ 'Style', 'text', 'string', 'Threshold rejection', 'fontweight', 'bold' }, ...
	...
	{ }, { 'Style', 'text', 'string', 'Positive (mv/std)' }, ...
	{ 'Style', 'edit', 'string', '25', 'tag', 'threshpos' }, ...
	{ 'Style', 'text', 'string', 'Negative (mv/std)' }, ...
	{ 'Style', 'edit', 'string', '-25', 'tag', 'threshneg' }, ...
	...
	{ }, { 'Style', 'text', 'string', 'Startime (ms)' }, ...
	{ 'Style', 'edit', 'string', int2str(EEG.xmin*1000), 'tag', 'threshstart' }, ...
	{ 'Style', 'text', 'string', 'Endtime (ms)' }, ... 
	{ 'Style', 'edit', 'string', int2str(EEG.xmax*1000), 'tag', 'threshend' }, ...
	...
	{ }, { 'Style', 'text', 'string', 'Electrodes/component list' }, ...
	{ 'Style', 'edit', 'string', [ '1:' int2str(EEG.nbchan) ], 'tag', 'threshelec' }, ...
	{ 'Style', 'text', 'string', 'Trials rejected:' }, ...
	{ 'Style', 'text', 'string', '0', 'tag', 'threshtrial' }, ...
	...
	{ }, { 'Style', 'pushbutton', 'string', 'CALC/PLOT', 'callback', cb_compthresh }, ...
	{ }, { },{ 'Style', 'pushbutton', 'string', 'HELP', 'callback', 'pophelp(''pop_eegthresh'');' }, ...
	... % ---------------------------------------------------------------------------
	{ }, { 'Style', 'text', 'string', 'Rejection of stable activity windows', 'fontweight', 'bold' }, ...
	...
	{ }, { 'Style', 'text', 'string', 'Minimal slope (=amplitude)' }, ...
	{ 'Style', 'edit', 'string', '50', 'tag', 'constpnts' }, ...
	{ 'Style', 'text', 'string', 'Maximal R^2' }, ...
	{ 'Style', 'edit', 'string', '0.3', 'tag', 'conststd'  }, ...
    ...
	{ }, { 'Style', 'text', 'string', 'Electrodes/component list' }, ...
	{ 'Style', 'edit', 'string', [ '1:' int2str(EEG.nbchan) ], 'tag', 'constelec'  }, ...
	{ 'Style', 'text', 'string', 'Trials rejected:' }, ...
	{ 'Style', 'text', 'string', '0', 'tag', 'consttrial'  }, ...	
	...
	{ }, { 'Style', 'pushbutton', 'string', 'CALC/PLOT', 'callback', cb_compconstrej }, ...
	{ }, { }, { 'Style', 'pushbutton', 'string', 'HELP', 'callback', 'pophelp(''pop_rejtrend'');' }, ...
	...  % ---------------------------------------------------------------------------
	{ }, { 'Style', 'text', 'string', 'Probability rejection', 'fontweight', 'bold' }, ...
	...
	{ }, { 'Style', 'text', 'string', 'Local threshold' }, ...
	{ 'Style', 'edit', 'string', '5', 'tag', 'entloc' }, ...
	{ 'Style', 'text', 'string', 'Global thresold' }, ...
	{ 'Style', 'edit', 'string', '5', 'tag', 'entglob' }, ...
    ...
	{ }, { 'Style', 'text', 'string', 'Electrodes/component list' }, ...
	{ 'Style', 'edit', 'string', [ '1:' int2str(EEG.nbchan) ], 'tag', 'entelec' }, ...
	{ 'Style', 'text', 'string', 'Trials rejected:' }, ...
	{ 'Style', 'text', 'string', '0', 'tag', 'enttrial' }, ...	
	...
	{ }, { 'Style', 'pushbutton', 'string', 'CALC', 'callback', cb_compentcalc }, ...
	{ 'Style', 'pushbutton', 'string', 'EEGPLOT', 'callback', cb_compenteeg }, ...
	{ 'Style', 'pushbutton', 'string', 'PLOT', 'callback', cb_compentplot }, ...
	{ 'Style', 'pushbutton', 'string', 'HELP', 'callback', 'pophelp(''pop_jointprob'');' }, ...
	...  % ---------------------------------------------------------------------------
	{ }, { 'Style', 'text', 'string', 'Kurtosis rejection', 'fontweight', 'bold' }, ...
	...
	{ }, { 'Style', 'text', 'string', 'Local threshold' }, ...
	{ 'Style', 'edit', 'string', '5', 'tag', 'kurtloc' }, ...
	{ 'Style', 'text', 'string', 'Global thresold' }, ...
	{ 'Style', 'edit', 'string', '5', 'tag', 'kurtglob' }, ...
    ...
	{ }, { 'Style', 'text', 'string', 'Electrodes/component list' }, ...
	{ 'Style', 'edit', 'string', [ '1:' int2str(EEG.nbchan) ], 'tag', 'kurtelec' }, ...
	{ 'Style', 'text', 'string', 'Trials rejected:' }, ...
	{ 'Style', 'text', 'string', '0', 'tag', 'kurttrial' }, ...	
	...
	{ }, { 'Style', 'pushbutton', 'string', 'CALC', 'callback', cb_compkurtcalc }, ...
	{ 'Style', 'pushbutton', 'string', 'EEGPLOT', 'callback', cb_compkurteeg }, ...
	{ 'Style', 'pushbutton', 'string', 'PLOT', 'callback', cb_compkurtplot }, ...
	{ 'Style', 'pushbutton', 'string', 'HELP', 'callback', 'pophelp(''pop_kurtosis'');' }, ...
	... % ---------------------------------------------------------------------------
	{ }, { 'Style', 'text', 'string', 'Threshold frequency rejection', 'fontweight', 'bold' }, ...
	...
	{ }, { 'Style', 'text', 'string', 'highter threshold' }, ...
	{ 'Style', 'edit', 'string', '25', 'tag', 'freqpos' }, ...
	{ 'Style', 'text', 'string', 'Lower threshold' }, ...
	{ 'Style', 'edit', 'string', '-25', 'tag', 'freqneg' }, ...
	...
	{ }, { 'Style', 'text', 'string', 'Beginning frequency' }, ...
	{ 'Style', 'edit', 'string', '0', 'tag', 'freqstart' }, ...
	{ 'Style', 'text', 'string', 'Ending frequency' }, ... 
	{ 'Style', 'edit', 'string', '50', 'tag', 'freqend' }, ...
	...
	{ }, { 'Style', 'text', 'string', 'Electrodes/component list' }, ...
	{ 'Style', 'edit', 'string', [ '1:' int2str(EEG.nbchan) ], 'tag', 'freqelec' }, ...
	{ 'Style', 'text', 'string', 'Trials rejected:' }, ...
	{ 'Style', 'text', 'string', '0', 'tag', 'freqtrial' }, ...
	...
	{ }, { 'Style', 'pushbutton', 'string', 'CALC/PLOT', 'callback', cb_compfreq }, ...
	{ }, { },{ 'Style', 'pushbutton', 'string', 'HELP', 'callback', 'pophelp(''pop_rejspec'');' }, ...
    ...
    {}, ...  % ---------------------------------------------------------------------------
	...
	{ 'Style', 'text', 'string', 'Drawing options (when vizualising all, also used for reject button)', 'fontweight', 'bold' }, ...
	{ 'style', 'listbox', lisboxoptions{:} }, ...
	{ 'style', 'checkbox', 'String', 'Include manual', 'tag', 'IManual', 'value', 1}, ...
	{ 'style', 'checkbox', 'String', 'Include threshold', 'tag', 'IThresh', 'value', 1}, ...
	{ 'style', 'checkbox', 'String', 'Include constant', 'tag', 'IConst', 'value', 1}, ...
	{ 'style', 'checkbox', 'String', 'Include entropy', 'tag', 'IEnt', 'value', 1}, ...
	{ 'style', 'checkbox', 'String', 'Include kurtosis', 'tag', 'IKurt', 'value', 1}, ...
	{ 'style', 'checkbox', 'String', 'Include frequency', 'tag', 'IFreq', 'value', 1}, ...
	{ 'style', 'checkbox', 'String', ['Include ' fastif(typerej, 'raw data', 'ica data')], 'tag', 'IOthertype', 'value', 1}, { }, ...
	...
	{ }, ...
 	{ 'Style', 'pushbutton', 'string', 'CLOSE', 'callback', 'close gcbf' }, ...
 	{ 'Style', 'pushbutton', 'string', 'CLEAR', 'callback', cb_clear  }, ...
	{ 'Style', 'pushbutton', 'string', 'REJECT', 'callback', cb_reject });


set(gcf, 'userdata', { allh });	
set( findobj('parent', gcf, 'tag', 'rejstatus'), 'style', 'popup');

pos = get(gcf, 'position');
set(gcf, 'position', [ pos(1:2) 700 1000]); 
	 
