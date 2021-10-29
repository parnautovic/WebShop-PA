page 50130 "ItemPA"
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
                field(image; getItemImage(Rec))
                {

                }
            }
        }
    }


    local procedure getItemImage(var Item: Record Item): Text
    var
        TenantMedia: Record "Tenant Media";
        Base64Convert: Codeunit "Base64 Convert";
        MediaInStream: InStream;
        MediaJsonObject: JsonObject;
        MediaJsonToken: JsonToken;
    begin
        if Item.Picture.Count = 0 then
            exit('');
        TenantMedia.Get(Item.Picture.Item(1));
        TenantMedia.CalcFields(Content);
        if not TenantMedia.Content.HasValue() then
            exit('');
        TenantMedia.Content.CreateInStream(MediaInStream, TextEncoding::Windows);

        MediaJsonObject.Add('image', Base64Convert.ToBase64(MediaInStream));
        MediaJsonObject.SelectToken('image', MediaJsonToken);

        exit(MediaJsonToken.AsValue().AsText());
    end;
}
