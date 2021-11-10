pageextension 50130 "BCItemCardExt" extends "Item Card"
{
    layout
    {
        addafter("Item Category Code")
        {
            field(BCAuthor; Rec.BCAuthor)
            {
                ApplicationArea = All;
                Importance = Promoted;
                ToolTip = 'Specifies the value of the Author field.';
                Caption = 'Author';

            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }


}