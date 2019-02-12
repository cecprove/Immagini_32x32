%% %%%%%%%%                                 P1 (32x32)
%% Creare il database
imagespath=dir('C:\Users\cecil\Documents\Universita\ElaborazioneImmagini\Progetto\Database_per_gli_elaborati_di_Tipo_2_20190202\Yale\Yale');
imagespath
ImagesPath=imagespath(4:end,:);% Per eliminare i primi tre elementi che non sono immagini
images=struct;
lista_tipologie=struct;
for i=1:size(ImagesPath,1)
    images(i).images=imread([ImagesPath(i).folder,'/',ImagesPath(i).name]);
    % creo il path totale dell'immagine, quindi
    % sto caricando con ogni ciclo la struttura ad ogni immagine
    % Se volessi solo l'immagine 7 scriverò images(7).images e gli dico di
    % andare a prendere la settima immagine che ha  caricato nel database, in
    % questo caso la struct
    
    %creo struct con tuttii nomi delle immagini
    lista_tipologie(i).lista = extractAfter(ImagesPath(i).name,".");
end
 
 
%creo array di stringhe che conterrà i nomi delle 11 tipologie delle
%immagini
lista_stringhe = string(lista_tipologie(1).lista);
 
for i=1:size(lista_tipologie,2)
    %prendo tutti i nomi dalla struct e li confronto con quelli presente in
    %lista_stringhe
    count = 0;
    for k=1:size(lista_stringhe,1)
        if count ==0 && ~strcmp(lista_tipologie(i).lista, lista_stringhe(k))
        else
            count = 1;
        end
    end
    if count == 0
        %aggiungo la nuova tipologia in lista_stringhe
        lista_stringhe = [lista_stringhe;string(lista_tipologie(i).lista)];
    end
end
 
%% %%%%% P1
%% Costruire per ogni immagine una thumbnail (32x32)
% Quindi attraverso un ciclo for costruisco una thumbnail per ogni immagine
thumbnail_32x32= struct;
for i=1:size(ImagesPath,1)
    thumbnail_32x32(i).thumbnail_32x32=imresize(images(i).images,[32 32]);
end
% per prova: imshowpair(images(7).images,thumbnail_32x32(7).thumbnail_32x32,'montage')
 
 
%% Costruire le 11 thumbnail di riferimento (dominio dello spazio)
thumbnail_rif = struct;
% Quale immagine scegliamo per l'espessione sad tra queste?
 
% imshow(images(9).images,images(20).images,images(31).images,images(42).images,images(53).images,...
%     images(64).images,images(75).images,images(86).images,images(97).images,images(108).images,...
%     images(119).images,images(130).images,images(141).images,images(152).images,...
%     images(163).images)
%poniamo es 53
 
% Creiamo un vettore contenente gli indici delle immagini che prendiamo
% come riferimento nel dominio dello spazio
%k = [35 47 15 60 72 84 107 53 131 143 166]';
 
 
%creo riferimenti
stringa_sub = '01';
for i=1:size(lista_stringhe,1)
    for k=1:size(ImagesPath,1)
        if strcmp(extractAfter(ImagesPath(k).name,"."),lista_stringhe(i))&& ...
                strcmp(extractBefore(ImagesPath(k).name,"."),['subject',stringa_sub])
            thumbnail_rif(i).thumbnail_rif_space = imread([ImagesPath(k).folder,'/',ImagesPath(k).name]);
            thumbnail_rif(i).tipologia = extractAfter(ImagesPath(k).name,".");
            thumbnail_rif(i).soggetto = extractBefore(ImagesPath(k).name,".");
            switch stringa_sub
                case '01'
                    stringa_sub = '02';
                case '02'
                    stringa_sub = '03';
                case '03'
                    stringa_sub = '04';
                case '04'
                    stringa_sub = '05';
                case '05'
                    stringa_sub = '06';
                case '06'
                    stringa_sub = '07';
                case '07'
                    stringa_sub = '08';
                case '08'
                    stringa_sub = '09';
                case '09'
                    stringa_sub = '10';
                case '10'
                    stringa_sub = '11';
            end
            break;
        end
    end
end
 
%associo all immagini della thumbnail le etichette
for k=1:size(ImagesPath,1)
    for i=1:size(lista_stringhe,1)
        if strcmp(extractAfter(ImagesPath(k).name,"."),lista_stringhe(i))
            thumbnail_32x32(k).tipologia = extractAfter(ImagesPath(k).name,".");
        end
    end
end
 
 
for i=1:size(thumbnail_32x32,2)
    switch thumbnail_32x32(i).tipologia
        case 'glasses'
           thumbnail_32x32(i).etichetta = 1; 
        case 'happy'
            thumbnail_32x32(i).etichetta = 2;
        case 'leftlight'
            thumbnail_32x32(i).etichetta = 3;
        case 'noglasses'
            thumbnail_32x32(i).etichetta = 4;
        case 'normal'
            thumbnail_32x32(i).etichetta = 5;
        case 'rightlight'
            thumbnail_32x32(i).etichetta = 6;
        case 'sad'
            thumbnail_32x32(i).etichetta = 7;
        case 'sleepy'
            thumbnail_32x32(i).etichetta = 8;
        case 'surprised'
            thumbnail_32x32(i).etichetta = 9;
        case 'wink'
            thumbnail_32x32(i).etichetta = 10;
        case 'centerlight'
            thumbnail_32x32(i).etichetta = 11;
                  
    end
            
end
 
 
 
for i=1:size(thumbnail_rif,2)
    thumbnail_rif(i).thumbnail_rif_space=imresize(thumbnail_rif(i).thumbnail_rif_space,[32 32]);
  %  figure
  %  imshow(thumbnail_rif(i).thumbnail_rif_space);
end
 
 
 
%creo dominio di riferimento (DCT2)
for i=1:size(thumbnail_rif,2)
    thumbnail_rif(i).thumbnail_rif_freq = dct2(im2double(thumbnail_rif(i).thumbnail_rif_space));
    %creo etichette
    thumbnail_rif(i).etichetta = i;
end

%% Feature media delle parti 

elab_immagini_rif = struct;
for i=1:size(thumbnail_rif,2)
   [~, threshold] = edge(thumbnail_rif(i).thumbnail_rif_space, 'sobel');
   fudgeFactor = .2;
   elab_immagini_rif(i).imm_contorni = edge(thumbnail_rif(i).thumbnail_rif_space,'sobel', threshold * fudgeFactor);
end
%imshow(elab_immagini(3).imm_contorni)

for i=1:size(thumbnail_rif,2)
   elab_immagini_rif(i).imm_fill = imfill(elab_immagini_rif(i).imm_contorni, 'holes');
end
%figure
%imshow(elab_immagini(5).imm_fill)

background_rif= struct;
for i=1:size(thumbnail_rif,2)
   elab_immagini_rif(i).binary = imbinarize(thumbnail_rif(i).thumbnail_rif_space)
%prendo le due fasce laterali dell'immagine   
   background_rif(i).background = elab_immagini_rif(i).binary - elab_immagini_rif(i).imm_fill
end
%imshow(background(11).background)



for i=1:size(thumbnail_rif,2)
   background_rif(i).backpartesx = background_rif(i).background(1:32,1:8);
end
% imshow(background(4).backpartesx)

for i=1:size(thumbnail_rif,2)
   background_rif(i).backpartedx = background_rif(i).background(1:32,25:32);
end


%calcolo media

for i=1:size(thumbnail_rif,2)
   media_partesx_rif(i,1) = mean2(background_rif(i).backpartesx);
end


for i=1:size(thumbnail_rif,2)
   media_partedx_rif(i,1) = mean2(background_rif(i).backpartedx);
end
diff_media=media_partesx_rif-media_partedx_rif;

%% Effettuo la stessa cosa per tutte le immagini

elab_immagini = struct;
for i=1:size(thumbnail_32x32,2)
   [~, threshold] = edge(thumbnail_32x32(i).thumbnail_32x32, 'sobel');
   fudgeFactor = .2;
   elab_immagini(i).imm_contorni = edge(thumbnail_32x32(i).thumbnail_32x32,'sobel', threshold * fudgeFactor);
   
end
%imshow(elab_immagini(3).imm_contorni)

for i=1:size(thumbnail_32x32,2)
   elab_immagini(i).imm_fill = imfill(elab_immagini(i).imm_contorni, 'holes');
end
%figure
%imshow(elab_immagini(5).imm_fill)

background= struct;
for i=1:size(thumbnail_32x32,2)
   elab_immagini(i).binary = imbinarize(thumbnail_32x32(i).thumbnail_32x32)
%prendo le due fasce laterali dell'immagine   
    background(i).background = elab_immagini(i).binary - elab_immagini(i).imm_fill
end
%imshow(background(11).background)



for i=1:size(thumbnail_32x32,2)
   background(i).backpartesx = background(i).background(1:16,1:8);
end
% imshow(background(4).backpartesx)

for i=1:size(thumbnail_32x32,2)
   background(i).backpartedx = background(i).background(1:16,25:32);
end


%calcolo media

for i=1:size(thumbnail_32x32,2)
   media_partesx(i,1) = mean2(background(i).backpartesx);
end


for i=1:size(thumbnail_32x32,2)
   media_partedx(i,1) = mean2(background(i).backpartedx);
end

diff_media_totImm = media_partesx - media_partedx;




%% creo features di riferimento
for i=1:size(thumbnail_rif,2)
     feature_rif(i).etichetta =    thumbnail_rif(i).etichetta;
     feature_rif(i).media =  mean(mean(thumbnail_rif(i).thumbnail_rif_space));
     feature_rif(i).entropia = entropy(thumbnail_rif(i).thumbnail_rif_space);
     feature_rif(i).varianza = var(var(double(thumbnail_rif(i).thumbnail_rif_space)));
     feature_rif(i).mediaparti = diff_media(i);
     feature_rif(i).simmetria = skewness(skewness(double(thumbnail_rif(i).thumbnail_rif_space)));
 end
 
% %creo DB
% for i=1:size(thumbnail_rif,2)
%     DB(i,:)=[feature(i).media ,feature(i).entropia,thumbnail_rif(i).etichetta]; 
% end
 
 
%creo features per tutte le immagini
%devo togliere le 11 immagini di riferimento
for i=1:size(thumbnail_32x32,2)
    feature(i).entropia = entropy(thumbnail_32x32(i).thumbnail_32x32); 
    feature(i).media =  mean(mean(thumbnail_32x32(i).thumbnail_32x32));
    feature(i).varianza = var(var(double(thumbnail_32x32(i).thumbnail_32x32)));
    feature(i).mediaparti = diff_media_totImm(i);
    feature(i).simmetria = skewness(skewness(double(thumbnail_32x32(i).thumbnail_32x32)));
end
 
 
for i=1:size(thumbnail_rif,2)
  trovato = 0;
  for k=1:size(thumbnail_32x32,2)
      if thumbnail_rif(i).thumbnail_rif_space == thumbnail_32x32(k).thumbnail_32x32 
          thumbnail_32x32_senza_rif(k).thumbnail_32x32 = zeros(32);
          feature(k).media = 0;
          feature(k).entropia = 0;
          feature(k).varianza = 0; 
          feature(k).mediaparti = 0;
          feature(k).simmetria=0;
          trovato = 1;
          indici(i)=k;
      else
          if trovato == 1
          thumbnail_32x32_senza_rif(k).thumbnail_32x32 = thumbnail_32x32(k).thumbnail_32x32;
          end
      end
  end
end
 
for i=1:size(thumbnail_32x32_senza_rif,2)
    if mean(mean(double(thumbnail_32x32_senza_rif(i).thumbnail_32x32) == zeros(32))) ~= 1 
        thumbnail_32x32_senza_rif(i).tipologie = thumbnail_32x32(i).tipologia;
        thumbnail_32x32_senza_rif(i).etichetta = thumbnail_32x32(i).etichetta;
    end
end
 
%plot delle immagini di riferimento
  for i=1:size(feature_rif,2)
      scatter(feature_rif(i).entropia,feature_rif(i).varianza)
      %text(feature_rif(i).media,feature_rif(i).varianza,string(feature_rif(i).etichetta),'VerticalAlignment','bottom')
      hold on
  end
 
 for k= 1:size(thumbnail_32x32_senza_rif,2)
     if rank(double(thumbnail_32x32_senza_rif(k).thumbnail_32x32)) ~= 0
         for i= 1: size(thumbnail_rif,2)
                 distanze(i,k) = pdist([feature(k).entropia, feature(k).varianza;feature_rif(i).entropia,feature_rif(i).varianza]);  
                 %distanze(i,k) = pdist([feature(k).media, feature(k).entropia,feature(k).mediaparti;feature_rif(i).media,feature_rif(i).entropia, feature_rif(i).mediaparti]);  
                 %distanze(i,k) = pdist([feature(k).entropia,feature(k).mediaparti;feature_rif(i).entropia, feature_rif(i).mediaparti]);
                 %distanze(i,k) = pdist([feature(k).media,feature(k).mediaparti;feature_rif(i).media, feature_rif(i).mediaparti]);
                 %distanze(i,k) = pdist([feature(k).simmetria,feature(k).mediaparti;feature_rif(i).simmetria, feature_rif(i).mediaparti]);
         end
     end  
 end
 
 
 counter=0;
 for k= 1:size(thumbnail_32x32_senza_rif,2)
     if sum(distanze(:,k)) ~= 0
        [minimo,index] = min(distanze(:,k));
        verita(k).minimi = minimo;
        verita(k).etichetta_calcolata = index;
        verita(k).etichetta_vera = thumbnail_32x32_senza_rif(k).etichetta;
        if verita(k).etichetta_calcolata == verita(k).etichetta_vera
            verita(k).gt=1;
            counter = counter+1;
        else
            verita(k).gt=0;
        end
     end
 end

