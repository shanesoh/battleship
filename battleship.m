function battleship(n, ships)
%A game of Battleship
%n: number of cells one each side of playing field
%ships: m by 2 cell array containing m number of ships
%the first column contains the names of the ships in a string
%the second column contains the sizes of the ships
%e.g. ships= {'aircraft carrier', 5; 'battleship', 4; 'submarine', 3;
%'destroyer', 3; 'patrol boat', 2};
%the above inputs the ships and their corresponding sizes as per the
%assignment handout

close all
clear all
figure
axis equal off
hold on
running= 1; % true if game is running, false otherwise

%%%%%%%%% TO BE REMOVED %%%%%%%%%%%
%%%%%%%%% These are prefixed parameters for testing purposes %%%%%%
% 1 - aircraft carrier (5 squares)
% 2 - battleship (4 squares)
% 3 - submarine (3 squares)
% 4 - destroyer (3 squares)
% 5 - patrol boat (2 squares)
n= 10; %size of grid is n x n
% ship array: keeps track of ship name and life sorted according to ship
% index
ships= {'aircraft carrier', 5; 'battleship', 4; 'submarine', 3; 'destroyer', 3; 'patrol boat', 2};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Draw grid
for i=0:n-1
    for j=0:n-1
        % Draw tile (i,j)
        fill([i i+1 i+1 i i],[j j j+1 j+1 j],'b')
    end
end

% matrix that keeps track if square is occupied, and if so, by which ship
% 0 means square is not occupied by part of a ship
% if occupied, fill matrix with index of ship
occ= zeros(10);

%Place ships
orientation = ceil(rand*2); %1 means vertical, 2 means horizontal
[numShips d] = size(ships);
for shipIndex= 1:numShips %i.e. for all indices that represent all ships
    shipSize= ships{shipIndex,2};
    
    %generate valid position
    valid = 0;
    while valid == 0
        if orientation == 2
            x= ceil(rand*(n-shipSize)); %generate random x position subtracting shipSize to
            %account for the ship occupying spaces beyond the boundaries of the
            %grid
            y= ceil(rand*n); %generate random y position
            if sum(occ(x:x+shipSize-1,y)~=0) == 0 %if entire length of squares is 0
                valid = 1;
            end
        elseif orientation == 1
            x= ceil(rand*n); %generate random x position subtracting shipSize to
            %account for the ship occupying spaces beyond the boundaries of the
            %grid
            y= ceil(rand*(n-shipSize)); %generate random y position
            if sum(occ(x,y:y+shipSize-1)~=0) == 0 %if entire length of squares is 0
                valid = 1;
            end
        end
    end
    
    %now with valid position, place ship
    if orientation == 2
        for rem2=0:shipSize-1 %remaining squares of the ship
            occ(x+rem2,y) = shipIndex;
        end
    elseif orientation == 1
        for rem2=0:shipSize-1 %remaining squares of the ship
            occ(x,y+rem2) = shipIndex;
        end
    end
end

squares= zeros(n); % 0 means covered, 1 means uncovered
movesMade = 0; %initialise number of moves to be 0
titleText='Welcome to Battleship';
movesMadeText= sprintf('Number of Moves Made: %d',movesMade);
while running== 1

    title({titleText, movesMadeText}, 'FontSize', 14');
    [x,y] = ginput(1);
    X= ceil(x);
    Y= n-ceil(y)+1;
    % user clicks on a square
    if X<=n && Y <=n && X>=1 && Y>=1 % ensures user clicks within playing field
        if squares(X,Y)==0 % square is covered, then uncover it
            squares(X,Y)= 1;
            movesMade = movesMade + 1;
            if occ(X,Y)~=0 % if square contains part of a ship
                titleText= 'Hit!';
                movesMadeText= sprintf('Number of Moves Made: %d',movesMade);
                ships{occ(X,Y),2}= ships{occ(X,Y),2} - 1; %decrease life of ship by 1
                fill ([X-1 X X X-1 X-1],[n-Y n-Y n-Y+1 n-Y+1 n-Y],'r');
            else % if square does not contain part of a ship
                titleText= 'Miss!';
                movesMadeText= sprintf('Number of Moves Made: %d',movesMade);
                fill ([X-1 X X X-1 X-1],[n-Y n-Y n-Y+1 n-Y+1 n-Y],'w');
            end
        elseif squares(X,Y)==1 % square is already uncovered, ask player to choose again
            titleText='Square already clicked on. Try again.';
            movesMadeText= sprintf('Number of Moves Made: %d',movesMade);
        end
    end
        %check if any ship has been sunk
    sumS= 0;
    for shipIndex= 1:numShips
        if ships{shipIndex,2}==0
            ships{shipIndex,2} = -1; %-1 means that ship has been sunk
            shipName= ships{shipIndex,1};
            titleText= sprintf('You sunk a %s',shipName);
            movesMadeText= sprintf('Number of Moves Made: %d',movesMade);
        end
        sumS= sumS + ships{shipIndex,2};
        if sumS== -1 * numShips %all ships have been sunk
            titleText= 'YOU WIN!';
            title({titleText, movesMadeText}, 'FontSize', 14');
            running = 0;
        end
    end
end
end