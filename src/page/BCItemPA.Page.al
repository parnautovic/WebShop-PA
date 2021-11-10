page 50130 "BCItemPA"
{

    APIGroup = 'webShop';
    APIPublisher = 'beTerna';
    APIVersion = 'v1.0';
    Caption = 'item';
    DelayedInsert = true;
    EntityName = 'itemPA';
    EntitySetName = 'itemsPA';
    PageType = API;
    SourceTable = Item;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General';
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(unitPrice; Rec."Unit Price")
                {
                    Caption = 'Unit Price';
                }

                field(intern; Rec.BCIntern)
                {
                    Caption = 'Intern';
                }
                field(author; Rec.BCAuthor)
                {
                    Caption = 'Author';
                }

                field(itemcategory; Rec."Item Category Code")
                {
                    Caption = 'Item Category Code';
                }
                field(imageDataBase64; ImageDataBase64)
                {
                    Caption = 'ImageDataBase64';
                }
                field(mime; Mime)
                {
                    Caption = 'Mime';
                }
                field(pictureName; PictureName)
                {
                    Caption = 'PictureName';
                }
            }
        }
    }


    // local procedure getItemImage(var Item: Record Item): Text
    // var
    //     TenantMedia: Record "Tenant Media";
    //     Base64Convert: Codeunit "Base64 Convert";
    //     MediaInStream: InStream;
    //     MediaJsonObject: JsonObject;
    //     MediaJsonToken: JsonToken;
    // begin
    //     if Item.Picture.Count = 0 then
    //         exit('');
    //     TenantMedia.Get(Item.Picture.Item(1));
    //     TenantMedia.CalcFields(Content);
    //     if not TenantMedia.Content.HasValue() then
    //         exit('');
    //     TenantMedia.Content.CreateInStream(MediaInStream, TextEncoding::Windows);

    //     MediaJsonObject.Add('image', Base64Convert.ToBase64(MediaInStream));
    //     MediaJsonObject.SelectToken('image', MediaJsonToken);

    //     exit(MediaJsonToken.AsValue().AsText());
    // end;


    var
        ImageDataBase64: Text;
        PictureName: Text;
        Mime: Text;

    trigger OnAfterGetCurrRecord()
    begin
        exportPictureToAPI(Rec);
    end;

    // Exports data such as file name, file binary in base 64 and mime type to API.
    // Only a single picture from MediaSet is exported.
    local procedure exportPictureToAPI(var Item: Record Item)
    var
        TenantMedia: Record "Tenant Media";
        Base64Convert: Codeunit "Base64 Convert";
        MediaInStream: InStream;
    begin
        if Item.Picture.Count = 0 then begin
            ImageDataBase64 := 'No Content';
            Mime := '';
            PictureName := '';
            exit;
        end;

        TenantMedia.Get(Item.Picture.Item(1));
        TenantMedia.CalcFields(Content);

        if TenantMedia.Content.HasValue() then begin
            TenantMedia.Content.CreateInStream(MediaInStream, TextEncoding::Windows);
            ImageDataBase64 := Base64Convert.ToBase64(MediaInStream);
            Mime := TenantMedia."Mime Type";
            PictureName := Item."No." + ' ' + Item.Description + GetImgFileExtension(Mime);
        end;
    end;

    // Gets file exitension from mime type.
    local procedure GetImgFileExtension(Mime: Text): Text
    begin
        case Mime of
            'image/jpeg':
                exit('.jpg');
            'image/png':
                exit('.png');
            'image/bmp':
                exit('.bmp');
            'image/gif':
                exit('.gif');
            'image/tiff':
                exit('.tiff');
            'image/wmf':
                exit('.wmf');
            else
                exit('');
        end;
    end;
}
