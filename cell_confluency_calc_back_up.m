function varargout = cell_confluency_calc_back_up(varargin)
% CELL_CONFLUENCY_CALC_BACK_UP MATLAB code for cell_confluency_calc_back_up.fig
%      CELL_CONFLUENCY_CALC_BACK_UP, by itself, creates a new CELL_CONFLUENCY_CALC_BACK_UP or raises the existing
%      singleton*.
%
%      H = CELL_CONFLUENCY_CALC_BACK_UP returns the handle to a new CELL_CONFLUENCY_CALC_BACK_UP or the handle to
%      the existing singleton*.
%
%      CELL_CONFLUENCY_CALC_BACK_UP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CELL_CONFLUENCY_CALC_BACK_UP.M with the given input arguments.
%
%      CELL_CONFLUENCY_CALC_BACK_UP('Property','Value',...) creates a new CELL_CONFLUENCY_CALC_BACK_UP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cell_confluency_calc_back_up_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cell_confluency_calc_back_up_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cell_confluency_calc_back_up

% Last Modified by GUIDE v2.5 24-Jan-2014 23:10:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cell_confluency_calc_back_up_OpeningFcn, ...
                   'gui_OutputFcn',  @cell_confluency_calc_back_up_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before cell_confluency_calc_back_up is made visible.
function cell_confluency_calc_back_up_OpeningFcn(hObject, eventdata, handles, varargin)
cd ('C:\Program Files\MATLAB\R2013a\bin\BigProject')
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cell_confluency_calc_back_up (see VARARGIN)

% Choose default command line output for cell_confluency_calc_back_up
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes cell_confluency_calc_back_up wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = cell_confluency_calc_back_up_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
handles.output = hObject;
[fn, pn] = uigetfile('*.jpg','Please select your image file');
impath = strcat(pn,fn);
set(handles.edit1,'string',impath);
I = imread(impath);
imshow(I,[]);
pause(5)
handles.BI = I;%backup gia toggle buttpn
run('grayklim.m');
CI= I; %backup gia mask ths eikonas black and white parakatw
run('filterit.m');
run ('gemiseholes.m');
imshow(I,[]);
pause(5)
level= graythresh(I)- 0.22;
blackwhite= im2bw(I,level);
blackwhite= bwareaopen(blackwhite,100);
imshow(blackwhite,[] )
handles.bw= blackwhite;
mask =uint8 (blackwhite);
handles.blackcell= CI.*mask;
imshow (handles.blackcell, [] )
pause(5)
guidata(hObject, handles);

% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function pushbutton1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
A = sum(sum(handles.bw));
cell_pixels = A;
all_pixels= numel(handles.bw);
handle.perc_nu=(cell_pixels/all_pixels*100)
handles.perc = [num2str(cell_pixels/all_pixels*100) '%'];
set(handles.edit2,'string',handles.perc )
hold
plot(handles.perc_nu)

% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in togglebutton1.
function  togglebutton1_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
	% Toggle button is pressed-take appropriate actionimshow  
  imshow( handles.BI , [] )
elseif button_state == get(hObject,'Min')
	imshow(handles.blackcell , [])
% Toggle button is not pressed-take appropriate action
end     
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton1.
function pushbutton1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% axes of the backround
ha = axes('units','normalized','position',[0 0 1 1]);
%   axes to the bottom
uistack(ha,'bottom');
% backround image used  
I=imread('texture.jpg');
hi = imagesc(I);
colormap gray
%  handlevisibility off 
% axis invisible
set(ha,'handlevisibility','off','visible','off')
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
