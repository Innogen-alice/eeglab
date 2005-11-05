% pop_editset() - Edit EEG dataset structure fields.
%
% Usage:
%   >> EEGOUT = pop_editset( EEG ); % pops-up a data entry window
%   >> EEGOUT = pop_editset( EEG, 'key', val,...); % no pop-up window
%
% Graphic interface (refer to a previous version of the GUI):
%   "Dataset name" - [Edit box] Name for the new dataset. 
%                  In the last column of the graphic interface, the "EEG.setname"
%                  text indicates which field of the EEG structure this parameter
%                  is corresponding to (in this case 'setname').
%                  Command line equivalent: 'setname'. 
%   "Data sampling rate" - [Edit box] In Hz. Command line equivalent: 'srate'
%   "Time points per epoch" - [Edit box] Number of data frames (points) per epoch.
%                  Command line equivalent: 'pnts'



%   "Start Time"   - [Edit box]

%   "Number of channels" - [Edit box] Number of data channels. 
%                  Command line equivalent: 'nbchan'
%   "Ref. channel indices or mode - [Edit box]




%   "Optional epoch start time" - [Edit box]  This edit box is only present for 
%                  data epoch and specify the epochs start time in ms. Epoch upper
%                  time limit is automatically calculated. 
%                  Command line equivalent: 'xmin'
%   "Channel locations file or array" - [Edit box] For channel data formats, see 
%                  >> readlocs help     Command line equivalent: 'chanlocs'
%   "ICA weights array or text/binary file" - [edit box] Import ICA weights from other 
%                  decompositions (e.g., same data, different conditions). 
%                  To use the ICA weights from another loaded dataset (n), enter 
%                  ALLEEG(n).icaweights. Command line equivalent: 'icaweights'
%   "ICA sphere array or text/binary file" - [edit box] Import ICA sphere matrix. 
%                  Infomax ICA decompositions may be defined by a sphere matrix 
%                  and an unmixing weight matrix (see above).  To use the sphere 
%                  matrix from another loaded dataset (n), enter ALLEEG(n).icasphere 
%                  Command line equivalent: 'icasphere'.


% REMOVE?
%   "Data reference" - [text] to change data reference, use menu Tools > Re-reference
%                  calling function pop_reref(). The reference can be a string, 
%                  'common' indicating an unknow common reference, 'averef' indicating
%                  average reference, or an array of integer containing the indices of
%                  the reference channels.
% /REMOVE?



%   "Subject code" - [Edit box]

%   "Task Condition" - [Edit box]

%   "Session number" - [Edit box]

%   "Subject group" - [Edit box]

%   "About this dataset" - [Edit box]




% Inputs:
%   EEG          - EEG dataset structure
%
% Optional inputs:
%   'setname'    - Name of the EEG dataset
%   'data'       - ['varname'|'filename'] Import data from a Matlab variable or file
%                  into an EEG data structure 
%   'dataformat' - ['array|matlab|ascii|float32le|float32be'] Input data format.
%                  'array' is a Matlab array in the global workspace.
%                  'matlab' is a Matlab file (which must contain a single variable).
%                  'ascii' is an ascii file. 'float32le' and 'float32be' are 32-bits
%                  float data files (little endian or big endian byte ordering).
%                  Data must be organised as (channels, timepoints) i.e. 
%                  channels = rows and timepoints = columns or (channels, timepoints, 
%                  epochs). For convenience, The data file is transposed if the number
%                  of rows is larger than the number of columns.
%   'subject'    - [string] subject code. For instance S01.
%   'condition'  - [string] task condition.
%   'group'      - [string] subject group. For instance 'patients' or 'control'.
%   'session'    - [integer] session number. 
%   'chanlocs'   - ['varname'|'filename'] Import a channel location file.
%                  For file formats, see >> help readlocs
%   'nbchan'     - [int] Number of data channels. 
%   'xmin'       - [real] Data start time (in seconds).
%   'pnts'       - [int] Number of data points per epoch (epoched data only)
%   'srate'      - [real] Data sampling rate in Hz. 
%   'ref'        - [string or integer] reference channel indices. 'averef' indicates
%                  average reference. Note that this does not perform referencing
%                  but only set the initial reference.
%   'icaweight'  - [matrix] ICA weight matrix. 
%   'icasphere'  - [matrix] ICA sphere matrix. By default, the sphere matrix 
%                  is initialized to the identity matrix if it is left empty.
%   'comments'   - [string] Comments on the dataset accessible through the EEGLAB
%                  main menu (Edit > About This Dataset). Use this to attach 
%                  background information about the data to the dataset.
% Outputs:
%   EEGOUT       - Modified EEG dataset structure
%
% Note:
%   To create a new dataset:
%   >> EEG = pop_editset( eeg_emptyset ); % eeg_emptyset() returns an empty dataset
%
%   To erase a variable, use '[]'. The following suppresses channel locations:
%   >> EEG = pop_editset( EEG, 'chanlocs', '[]');
%
% Author: Arnaud Delorme, CNL / Salk Institute, 2001
%
% See also: pop_importdata(), pop_select(), eeglab()

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
% Revision 1.47  2005/11/04 22:44:52  arno
% header
%
% Revision 1.46  2005/11/04 22:43:46  arno
% updating header
%
% Revision 1.45  2005/11/04 22:42:12  arno
% new fields, new gui
%
% Revision 1.44  2004/02/04 18:18:43  arno
% implementing binary read for weights and sphere
%
% Revision 1.43  2003/12/08 18:03:37  arno
% do not copy variable names
%
% Revision 1.42  2003/12/05 23:24:47  arno
% command line call problem
%
% Revision 1.41  2003/07/30 18:01:24  arno
% handling empty chanlocs
%
% Revision 1.40  2003/07/28 17:50:18  arno
% same
%
% Revision 1.39  2003/07/28 17:49:12  arno
% ref text
%
% Revision 1.38  2003/07/28 15:28:24  arno
% obsolete averef
%
% Revision 1.37  2003/05/29 21:45:53  arno
% allowing to import numerical data array from command line
%
% Revision 1.36  2003/05/22 01:48:49  arno
% debug icaweight/icasphere
%
% Revision 1.35  2003/03/04 20:11:57  arno
% header typo
%
% Revision 1.34  2003/02/25 01:00:53  scott
% header edit -sm
%
% Revision 1.33  2003/02/24 16:26:38  arno
% resolving ???
%
% Revision 1.32  2003/02/22 17:11:31  scott
% header edit -sm
%
% Revision 1.31  2003/02/21 22:55:09  arno
% adding gui info
%
% Revision 1.30  2003/01/23 21:34:59  scott
% header edits -sm
%
% Revision 1.29  2003/01/22 22:43:53  scott
% edit header -sm
%
% Revision 1.28  2002/11/14 18:29:03  arno
% new average reference
%
% Revision 1.27  2002/11/14 17:38:31  arno
% gui text
%
% Revision 1.26  2002/11/08 19:05:05  arno
% test if array=string before importing it
%
% Revision 1.25  2002/09/25 23:49:58  arno
% correcting float-le problem
%
% Revision 1.24  2002/09/04 18:28:25  luca
% debug command line big variable passed as text - arno
%
% Revision 1.23  2002/08/29 23:17:01  arno
% debugging icaweights and sphere
%
% Revision 1.22  2002/08/26 22:03:01  arno
% average reference more message
%
% Revision 1.21  2002/08/12 18:31:31  arno
% questdlg2
%
% Revision 1.20  2002/07/31 18:12:35  arno
% reading floats le and be
%
% Revision 1.19  2002/05/21 20:47:02  scott
% removed ; from evalin() commands -sm
%
% Revision 1.18  2002/05/01 01:23:44  luca
% same
%
% Revision 1.17  2002/05/01 01:22:56  luca
% same
%
% Revision 1.16  2002/05/01 01:21:18  luca
% transpose bug
%
% Revision 1.15  2002/04/30 18:38:21  arno
% adding about button
%
% Revision 1.14  2002/04/18 16:19:38  scott
% EEG.averef -sm
%
% Revision 1.13  2002/04/18 16:13:20  scott
% working on EEG.averef -sm
%
% Revision 1.12  2002/04/18 14:43:02  scott
% edited error msgs -sm
%
% Revision 1.11  2002/04/18 02:52:05  scott
% [same] -sm
%
% Revision 1.10  2002/04/18 02:44:08  scott
% edited error messages -sm
%
% Revision 1.9  2002/04/18 02:29:24  arno
% further checks for matlab file import
%
% Revision 1.8  2002/04/11 18:28:58  arno
% adding average reference input
%
% Revision 1.7  2002/04/11 18:01:24  arno
% removing warning when removing ICA components
%
% Revision 1.6  2002/04/10 22:42:11  arno
% debuging variable name
%
% Revision 1.5  2002/04/08 02:29:33  scott
% *** empty log message ***
%
% Revision 1.4  2002/04/08 02:26:28  scott
% *** empty log message ***
%
% Revision 1.3  2002/04/08 02:25:00  scott
% *** empty log message ***
%
% Revision 1.2  2002/04/08 02:22:35  scott
% improved workding, moved 'EEG.data' placement -sm
%
% Revision 1.1  2002/04/05 17:32:13  jorn
% Initial revision
%

% 01-25-02 reformated help & license -ad 
% 03-16-02 text interface editing -sm & ad 
% 03-16-02 remove EEG.xmax et EEG.xmin (for continuous) -ad & sm
% 03-31-02 changed interface, reprogrammed all function -ad
% 04-02-02 recompute event latencies when modifying xmin -ad

function [EEGOUT, com] = pop_editset(EEG, varargin);
   
com = '';
if nargin < 1
   help pop_editset;
   return;
end;   

EEGOUT = EEG;
if nargin < 2                 % if several arguments, assign values 
   % popup window parameters	
   % -----------------------
   % popup window parameters	
   % -----------------------
    geometry    = { [2 3.38] [1] [2.5 1 1.5 1.5] [2.5 1 1.5 1.5] [2.5 1 1.5 1.5] [2.5 1 1.5 1.5] [2.5 1 1.5 1.5] ...
                    [1] [1.4 0.7 .8 0.5] [1] [1.4 0.7 .8 0.5] [1.4 0.7 .8 0.5] };
    editcomments = [ 'tmp = pop_comments(get(gcbf, ''userdata''), ''Edit comments of current dataset'');' ...
                     'if ~isempty(tmp), set(gcf, ''userdata'', tmp); end; clear tmp;' ];
    commandload = [ '[filename, filepath] = uigetfile(''*'', ''Select a text file'');' ...
                    'if filename ~=0,' ...
                    '   set(findobj(''parent'', gcbf, ''tag'', tagtest), ''string'', [ filepath filename ]);' ...
                    'end;' ...
                    'clear filename filepath tagtest;' ];
    commandselica = [ 'res = inputdlg2({ ''Enter dataset number'' }, ''Select ICA weights and sphere from other dataset'', 1, { ''1'' });' ...
                      'if ~isempty(res),' ...
                      '   set(findobj( ''parent'', gcbf, ''tag'', ''weightfile''), ''string'', sprintf(''ALLEEG(%s).icaweights'', res{1}));' ...
                      '   set(findobj( ''parent'', gcbf, ''tag'', ''sphfile'')   , ''string'', sprintf(''ALLEEG(%s).icasphere'' , res{1}));' ...
                      'end;' ];
    commandselchan = [ 'res = inputdlg2({ ''Enter dataset number'' }, ''Select channel information from other dataset'', 1, { ''1'' });' ...
                      'if ~isempty(res),' ...
                      '   set(findobj( ''parent'', gcbf, ''tag'', ''chanfile''), ' ...
                      '                ''string'', sprintf(''{ ALLEEG(%s).chanlocs ALLEEG(%s).chaninfo ALLEEG(%s).urchanlocs }'', res{1}, res{1}, res{1}));' ...
                      'end;' ];
    if isstr(EEGOUT.ref)
        curref = EEGOUT.ref;
    else
        if length(EEGOUT.ref) > 1
            curref = [ int2str(abs(EEGOUT.ref)) ];
        else
            curref = [ int2str(abs(EEGOUT.ref)) ];
        end;
    end;
                        
    uilist = { ...
         { 'Style', 'text', 'string', 'Dataset name', 'horizontalalignment', 'right', ...
		   'fontweight', 'bold' }, { 'Style', 'edit', 'string', EEG.setname }, { } ...
         ...
         { 'Style', 'text', 'string', 'Data sampling rate (Hz)', 'horizontalalignment', 'right', 'fontweight', ...
		   'bold' }, { 'Style', 'edit', 'string', num2str(EEGOUT.srate) }, ...
         { 'Style', 'text', 'string', 'Subject code', 'horizontalalignment', 'right', ...
		    },   { 'Style', 'edit', 'string', EEG.subject }, ...
         { 'Style', 'text', 'string', 'Time points per epoch (0->continuous)', 'horizontalalignment', 'right', ...
		   },  { 'Style', 'edit', 'string', num2str(EEGOUT.pnts) }, ...
         { 'Style', 'text', 'string', 'Task condition', 'horizontalalignment', 'right', ...
		   },   { 'Style', 'edit', 'string', EEG.condition }, ...
         { 'Style', 'text', 'string', 'Start time (sec) (only for data epochs)', 'horizontalalignment', 'right', ...
		   }, { 'Style', 'edit', 'string', num2str(EEGOUT.xmin) }, ...
         { 'Style', 'text', 'string', 'Session number', 'horizontalalignment', 'right', ...
		   },   { 'Style', 'edit', 'string', EEG.session }, ...
         { 'Style', 'text', 'string', 'Number of channels (0->set from data)', 'horizontalalignment', 'right', ...
		    },   { 'Style', 'edit', 'string', EEG.nbchan 'enable' 'off' }, ...
         { 'Style', 'text', 'string', 'Subject group', 'horizontalalignment', 'right', ...
		   },   { 'Style', 'edit', 'string', EEG.group }, ...
         { 'Style', 'text', 'string', 'Ref. channel indices or mode (see help)', 'horizontalalignment', 'right', ...
		   }, { 'Style', 'edit', 'string', curref 'enable' 'off' }, ...
         { 'Style', 'text', 'string', 'About this dataset', 'horizontalalignment', 'right', ...
		   },   { 'Style', 'pushbutton', 'string', 'Enter comments' 'callback' editcomments }, ...
         { } ...
         { 'Style', 'text', 'string', 'Channel location file or info', 'horizontalalignment', 'right', 'fontweight', ...
		   'bold' }, {'Style', 'pushbutton', 'string', 'From other dataset', 'callback', commandselchan }, ...
         { 'Style', 'edit', 'string', '', 'horizontalalignment', 'left', 'tag',  'chanfile' }, ...
         { 'Style', 'pushbutton', 'string', 'Browse', 'callback', [ 'tagtest = ''chanfile'';' commandload ] }, ...
         ...
         { 'Style', 'text', 'string', ...
           '      (note: autodetect file format using file extension; use menu "Edit > Channel locations" for more importing options)', ...
           'horizontalalignment', 'right' }, ...
         ...
         { 'Style', 'text', 'string', 'ICA weights array or text/binary file (if any):', 'horizontalalignment', 'right' }, ...
         { 'Style', 'pushbutton' 'string' 'from other dataset' 'callback' commandselica }, ...
         { 'Style', 'edit', 'string', '', 'horizontalalignment', 'left', 'tag',  'weightfile' }, ...
         { 'Style', 'pushbutton', 'string', 'Browse', 'callback', [ 'tagtest = ''weightfile'';' commandload ] }, ...
         ...
         { 'Style', 'text', 'string', 'ICA sphere array or text/binary file (if any):', 'horizontalalignment', 'right' },  ...
         { 'Style', 'pushbutton' 'string' 'from other dataset' 'callback' commandselica }, ...
         { 'Style', 'edit', 'string', '', 'horizontalalignment', 'left', 'tag',  'sphfile' } ...
         { 'Style', 'pushbutton', 'string', 'Browse', 'callback', [ 'tagtest = ''sphfile'';' commandload ] } };

    [ results newcomments ] = inputgui( geometry, uilist, 'pophelp(''pop_editset'');', 'Edit dataset information - pop_editset()', ...
                                         EEG.comments);
    if length(results) == 0, return; end;
	args = {};

    i = 1;
	if ~strcmp( results{i  },         EEG.setname   ) , args = { args{:}, 'setname',           results{i  }  }; end;    
	if ~strcmp( results{i+1}, num2str(EEG.srate)    ) , args = { args{:}, 'srate',     str2num(results{i+1}) }; end;
	if ~strcmp( results{i+2},         EEG.subject   ) , args = { args{:}, 'subject',           results{i+2}  }; end;
	if ~strcmp( results{i+3}, num2str(EEG.pnts)     ) , args = { args{:}, 'pnts',      str2num(results{i+3}) }; end;
	if ~strcmp( results{i+4},         EEG.condition ) , args = { args{:}, 'condition',         results{i+4}  }; end;
    if ~strcmp( results{i+5}, num2str(EEG.xmin)     ) , args = { args{:}, 'xmin',      str2num(results{i+5}) }; end;
    if ~strcmp( results{i+6}, num2str(EEG.session)  ) , args = { args{:}, 'session',   str2num(results{i+6}) }; end;
	if ~strcmp( results{i+7}, num2str(EEG.nbchan)   ) , args = { args{:}, 'nbchan',    str2num(results{i+7}) }; end;
    if ~strcmp( results{i+8},        EEG.group      ) , args = { args{:}, 'group',             results{i+8}  }; end;
    if ~strcmp( results{i+9}, num2str(EEG.ref)      ) , args = { args{:}, 'ref',               results{i+9}  }; end;
    if ~strcmp(EEG.comments, newcomments)             , args = { args{:}, 'comments' , newcomments }; end;
    
    if abs(str2num(results{i+5})) > 10,
        fprintf('WARNING: are you sure the epoch start time (%3.2f) is in seconds\n');
    end;
    
	if ~isempty( results{i+10} ) , args = { args{:}, 'chanlocs' ,  results{i+10} }; end;
	if ~isempty( results{i+11} ),  args = { args{:}, 'icaweights', results{i+11} }; end;
	if ~isempty( results{i+12} ) , args = { args{:}, 'icasphere',  results{i+12} }; end;
    args
    
else % no interactive inputs
    args = varargin;
    % Do not copy varargin
    % --------------------
    %for index=1:2:length(args)
    %    if ~isempty(inputname(index+2)) & ~isstr(args{index+1}) & length(args{index+1})>1, 
	%		args{index+1} = inputname(index+1); 
	%	end;
    %end;                
end;

% create structure
% ----------------
if ~isempty(args)
   try, g = struct(args{:});
   catch, disp('Setevent: wrong syntax in function arguments'); return; end;
else
    g = [];
end;

% test the presence of variables
% ------------------------------
try, g.dataformat;	 	  catch, g.dataformat = 'ascii'; end;

% assigning values
% ----------------
tmpfields = fieldnames(g);
for curfield = tmpfields'
    switch lower(curfield{1})
        case {'dataformat' }, ; % do nothing now
        case 'setname'   , EEGOUT.setname   = getfield(g, {1}, curfield{1});
        case 'subject'   , EEGOUT.subject   = getfield(g, {1}, curfield{1});
        case 'condition' , EEGOUT.condition = getfield(g, {1}, curfield{1});
        case 'group'     , EEGOUT.group     = getfield(g, {1}, curfield{1});
        case 'session'   , EEGOUT.session   = getfield(g, {1}, curfield{1});
        case 'setname'   , EEGOUT.setname   = getfield(g, {1}, curfield{1});
        case 'setname'   , EEGOUT.setname   = getfield(g, {1}, curfield{1});
        case 'pnts'      , EEGOUT.pnts      = getfield(g, {1}, curfield{1});
        case 'comments'  , EEGOUT.comments  = getfield(g, {1}, curfield{1});
        case 'nbchan'    , tmp              = getfield(g, {1}, curfield{1});
                           if tmp ~=0, EEGOUT.nbchan = tmp; end;
	    case 'averef'    , disp('The ''averef'' argument is obsolete; use function pop_reref() instead');
        case 'ref'       , EEGOUT.ref       = getfield(g, {1}, curfield{1});
                           disp('WARNING: CHANGING REFERENCE DOES NOT RE-REFERENCE THE DATA, use menu Tools > Rereference instead');
                           if ~isempty(str2num( EEGOUT.ref )), EEG,ref = str2num(EEG.ref); end;
        case 'xmin'    , oldxmin = EEG.xmin;
                         EEGOUT.xmin = getfield(g, {1}, curfield{1});
                         if oldxmin ~= EEGOUT.xmin
                             if ~isempty(EEG.event)
                                 if nargin < 2
                                     if ~popask( ['Warning: changing the starting point of epochs will' 10 'lead to recomputing epoch event latencies ?'] )
                                         com = ''; warndlg2('Pop_editset: transformation cancelled by user'); return; 
                                     end;
                                 end;
                                 if isfield(EEG.event, 'latency')
                                     for index = 1:length(EEG.event)
                                         EEG.event(index).latency = EEG.event(index).latency - (EEG.xmin-oldxmin)*EEG.srate;
                                     end;
                                 end;       
                             end;    
                         end;
        case 'srate'   , EEGOUT.srate = getfield(g, {1}, curfield{1});
        case 'chanlocs', varname = getfield(g, {1}, curfield{1});
                         if isempty(varname)
                             EEGOUT.chanlocs = [];
                         elseif isstr(varname) & exist( varname ) == 2
                            fprintf('Pop_editset: channel locations file ''%s'' found\n', varname); 
                            [ EEGOUT.chanlocs lab theta rad ind EEGOUT.chaninfo ] = readlocs(varname);
                         elseif isstr(varname)
                            EEGOUT.chanlocs = evalin('base', varname, 'fprintf(''Pop_editset warning: variable ''''%s'''' not found, ignoring\n'', varname)' );
                            if iscell(EEGOUT.chanlocs)
                                if length(EEGOUT.chanlocs) > 1, EEGOUT.chaninfo   = EEGOUT.chanlocs{2}; end;
                                if length(EEGOUT.chanlocs) > 2, EEGOUT.urchanlocs = EEGOUT.chanlocs{3}; end;
                                EEGOUT.chanlocs = EEGOUT.chanlocs{1};
                            end;
                         else
                             EEGOUT.chanlocs = varname;
                         end;
        case 'icaweights', varname = getfield(g, {1}, curfield{1});
                         if isstr(varname) & exist( varname ) == 2
                            fprintf('Pop_editset: ICA weight matrix file ''%s'' found\n', varname); 
							try, EEGOUT.icaweights = load(varname, '-ascii');
								EEGOUT.icawinv = [];
                            catch, 
                                try
                                    EEGOUT.icaweights = floatread(varname, [1 Inf]);
                                    EEGOUT.icaweights = reshape( EEGOUT.icaweights, [length(EEGOUT.icaweights)/EEG.nbchan EEG.nbchan]);
                                catch
                                    fprintf('Pop_editset warning: error while reading filename ''%s'' for ICA weight matrix\n', varname); 
                                end;
                            end;
                         else
							 if isempty(varname) 
								 EEGOUT.icaweights = [];
							 elseif isstr(varname)
								 EEGOUT.icaweights = evalin('base', varname, 'fprintf(''Pop_editset warning: variable ''''%s'''' not found, ignoring\n'', varname)' );
								 EEGOUT.icawinv = [];
                             else
								 EEGOUT.icaweights = varname;
								 EEGOUT.icawinv = [];                                 
							 end;
						 end;
                         if ~isempty(EEGOUT.icaweights) & isempty(EEGOUT.icasphere)
                            EEGOUT.icasphere = eye(size(EEGOUT.icaweights,2));
                         end;
        case 'icasphere', varname = getfield(g, {1}, curfield{1});
                         if isstr(varname) & exist( varname ) == 2
                            fprintf('Pop_editset: ICA sphere matrix file ''%s'' found\n', varname); 
                            try, EEGOUT.icasphere = load(varname, '-ascii');
								EEGOUT.icawinv = [];
                            catch,
                                try
                                    EEGOUT.icasphere = floatread(varname, [1 Inf]);
                                    EEGOUT.icasphere = reshape( EEGOUT.icasphere, [length(EEGOUT.icasphere)/EEG.nbchan EEG.nbchan]);
                                catch
                                    fprintf('Pop_editset warning: erro while reading filename ''%s'' for ICA weight matrix\n', varname); 
                                end;
                            end;
                         else
							 if isempty(varname) 
								 EEGOUT.icasphere = [];
							 elseif isstr(varname)
								 EEGOUT.icasphere = evalin('base', varname, 'fprintf(''Pop_editset warning: variable ''''%s'''' not found, ignoring\n'', varname)' );
								 EEGOUT.icawinv = [];
                             else
  								 EEGOUT.icaweights = varname;
								 EEGOUT.icawinv = [];                                 
							 end;
                         end;
                         if ~isempty(EEGOUT.icaweights) & isempty(EEGOUT.icasphere)
                            EEGOUT.icasphere = eye(size(EEGOUT.icaweights,2));
                         end;
	    case 'data'    , varname = getfield(g, {1}, curfield{1});
                         if isnumeric(varname)
                             EEGOUT.data = varname;
                         elseif exist( varname ) == 2 & ~strcmp(lower(g.dataformat), 'array');
                            fprintf('Pop_editset: raw data file ''%s'' found\n', varname); 
                            switch lower(g.dataformat)
							 case 'ascii' , 
							  try, EEGOUT.data = load(varname, '-ascii');
							  catch, error(['Pop_editset error: cannot read ascii file ''' varname ''' ']); 
							  end;
							  if ndims(EEGOUT.data)<3 & size(EEGOUT.data,1) > size(EEGOUT.data,2), EEGOUT.data = transpose(EEGOUT.data); end;
							 case 'matlab', 
							  try,
								  x = whos('-file', varname);
								  if length(x) > 1, 
									  error('Pop_editset error: .mat file must contain a single variable'); 
								  end;
								  tmpdata = load(varname, '-mat');									  
								  EEGOUT.data = getfield(tmpdata,{1},x(1).name);
								  clear tmpdata;
							  catch, error(['Pop_editset error: cannot read .mat file ''' varname ''' ']); 
							  end;
							  if ndims(EEGOUT.data)<3 & size(EEGOUT.data,1) > size(EEGOUT.data,2), EEGOUT.data = transpose(EEGOUT.data); end;
							 case {'float32le' 'float32be'}, 
							  if EEGOUT.nbchan == 0,
								  error(['Pop_editset error: to read float32 data you must first specify the number of channels']);
							  end;     
							  try, EEGOUT.data = floatread(varname, [EEGOUT.nbchan Inf], ...
														   fastif(strcmpi(g.dataformat, 'float32le'), 'ieee-le', 'ieee-be'));
							  catch, error(['Pop_editset error: cannot read float32 data file ''' varname ''' ']); 
							  end;
							 otherwise, error('Pop_editset error: unrecognized file format');
                            end;
                         elseif isstr(varname)
                             % restoration command
                             %--------------------
                             try 
                                 res = evalin('base', ['exist(''' varname ''') == 1']);
                             catch
                                 disp('Pop_editset warning: cannot find specified variable in global workspace!');
                             end;
                             if ~res, 
                                 error('Pop_editset: cannot find specified variable.'); 
                             end;
                             warning off;
                             try,
                                 testval = evalin('base', ['isglobal(' varname ')']);
                             catch, testval = 0; end;
                             if ~testval
                                 commandrestore = [ ' tmpp = '  varname '; clear global ' varname ';'   varname '=tmpp;clear tmpp;' ]; 
                             else
                                 commandrestore = [];
                             end;		  
                             % make global, must make these variable global, if you try to evaluate them direclty in the base
                             % workspace, with a large array the computation becomes incredibly slow.  
                             %--------------------------------------------------------------------
                             comglobal = sprintf('global %s;', varname);
                             evalin('base', comglobal);
                             eval(comglobal);
                             eval( ['EEGOUT.data = ' varname ';' ]);
                             try, evalin('base', commandrestore); catch, end;
                             warning on;
                         else 
                             EEGOUT.data = varname;
                             if ndims(EEGOUT.data)<3 & size(EEGOUT.data,1) > size(EEGOUT.data,2), EEGOUT.data = transpose(EEGOUT.data); end;
                         end;
         otherwise, error(['Pop_editset error: unrecognized field ''' curfield{1} '''']); 
    end;
end;

% generate the output command
% ---------------------------
if nargout > 1
    com = sprintf( '%s = pop_editset(%s', inputname(1), inputname(1) );
    for i=1:2:length(args)
        if ~isempty( args{i+1} )
            if isstr( args{i+1} ) com = sprintf('%s, ''%s'', %s', com, args{i}, vararg2str(args{i+1}) );
            else                  com = sprintf('%s, ''%s'', [%s]', com, args{i}, num2str(args{i+1}) );
            end;
        else
            com = sprintf('%s, ''%s'', []', com, args{i} );
        end;
    end;
    com = [com ');'];
end;
return;

function num = popask( text )
	 ButtonName=questdlg2( text, ...
	        'Confirmation', 'Cancel', 'Yes','Yes');
	 switch lower(ButtonName),
	      case 'cancel', num = 0;
	      case 'yes',    num = 1;
	 end;
