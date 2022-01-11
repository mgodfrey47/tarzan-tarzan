function TarzanTarzan
%% Tarzan Tarzan
% For playing the game 'Tarzan Tarzan' on Zoom

%% Change before game
people = {'Steven';
          'Pearl';
          'Connie';
          'Garnet';
          'Rose'};

things = {'Tarzan';
          'Jane';
          'Snake';
          'Tiger';
          'Exploding chicken'};

%% For later
np = length(people); %number of people
pInd = 1:np; %which thing each person has
oldpInd = pInd; %to store for undo button
i = pInd;

%% Create window
xpos = 10; ypos = 70; % window position - bottom left corner
w = 950; h = 900; % window size 

bgColor = [0.85,0.94,1]; % background colour in RGB

fig = figure;
fig.Name = 'TarzanTarzan';
fig.Position = [xpos,ypos,w,h];
fig.Color = bgColor;
fig.MenuBar = 'none';
fig.ToolBar = 'none';

%% Coordinates of points on circle
r = 0.4;
angl = 2*pi/np;
for n = 1:np
    x(n) = r*cos(angl*n);
    y(n) = r*sin(angl*n);
end
x = (x+0.43)*(w-120);
y = (y+0.45)*(h-100);

xn = x/w; % normalised coordinates
yn = y/h;

%% UI components

% Mistake button
handles.mistakeButton = uicontrol(fig,'Style','pushbutton','Units','Normalized',...
    'Position',[0.75,0.05,0.2,0.04],'String','Go to the end','FontSize',12);
handles.mistakeButton.Callback = @mistakeButtonPushed;

% Drop down menu for selecting names
handles.thingsMenu = uicontrol(fig,'Style','popupmenu','String',things,'Units','Normalized',...
    'Position',[0.75,0.07,0.2,0.04],'FontSize',12);

% Undo button
handles.undoButton = uicontrol(fig,'Style','pushbutton','Units','Normalized',...
    'Position',[0.05,0.05,0.1,0.04],'String','Undo','FontSize',12);
handles.undoButton.Callback = @undoButtonPushed;

% Crown and exploding seagull images
imSize = 60;
imW = imSize/w;
imH = imSize/h;
axes('pos',[xn(1)+70/w,yn(1)+(100/h),imW,imH])
imshow('crown.png')
axes('pos',[xn(end)+70/w,yn(end)+(100/h),imW,imH])
imshow('gull.png')

% Text labels
labelW = 200/w;
labelH = 30/h;

for n = 1:np
    thingText = uicontrol(fig,'Style','text','Units','Normalized',...
    'Position',[xn(n),yn(n),labelW,labelH],'String',things{n},...
    'FontSize',15,'FontWeight','bold','BackgroundColor',bgColor);
    eval(sprintf('handles.thingText%i = thingText;',n));
    
    peopleText = uicontrol(fig,'Style','text','Units','Normalized',...
    'Position',[xn(n),yn(n)+60/h,labelW,labelH],'String',people{i(n)},...
    'FontSize',15,'BackgroundColor',[1,1,1]);
    eval(sprintf('handles.peopleText%i = peopleText;',n));
end

guidata(fig,handles);


function mistakeButtonPushed(src,~)
    handles = guidata(src);
    
    oldpInd = pInd;
    nMistake = get(handles.thingsMenu,'Value');
    pIndMistake = find(pInd==nMistake);
    pInd(pInd>nMistake) = pInd(pInd>nMistake)-1;
    pInd(pIndMistake) = np;
    [~,i]=sort(pInd);
    
    for nt = nMistake:np
        person = people{i(nt)};
        str = '''String''';
        eval(sprintf('set(handles.peopleText%i,%s,person)',nt,str));
    end
end

function undoButtonPushed(src,~)
    pInd = oldpInd;
    [~,i]=sort(pInd);
    for nu = 1:np
        person = people{i(nu)};
        str = '''String''';
        eval(sprintf('set(handles.peopleText%i,%s,person)',nu,str));
    end
end

end