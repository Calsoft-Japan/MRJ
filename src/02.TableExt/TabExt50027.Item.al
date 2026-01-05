tableextension 50027 "Item Ext" extends Item
{
    fields
    {
        field(50000; "Parts Category"; Option)
        {
            Caption = 'Parts Category';
            DataClassification = ToBeClassified;
            Description = 'UPG';
            OptionCaption = 'Standard,Quick Access,Rebuilt Parts,Document,SST,Chemical,Promotion,Oil,Others,J,K,L,M,N,O,P,Q';
            OptionMembers = Standard,"Quick Access","Rebuilt Parts",Document,SST,Chemical,Promotion,Oil,Others,J,K,L,M,N,O,P,Q;
        }
        field(50010; "Parts No. Update"; Option)
        {
            Caption = 'Parts No. Update';
            DataClassification = ToBeClassified;
            Description = 'UPG';
            OptionCaption = 'No Change,Simple,Multiple';
            OptionMembers = "No Change",Simple,Multiple;
        }
        field(50020; "AT Parts Segment"; Option)
        {
            Caption = 'AT Parts Segment';
            DataClassification = ToBeClassified;
            Description = 'UPG';
            OptionCaption = 'None,Core Recall Item';
            OptionMembers = "None","Core Recall Item";
        }
        field(50030; "Pre-Pack Parts"; Option)
        {
            Caption = 'Pre-Pack Parts';
            DataClassification = ToBeClassified;
            Description = 'UPG';
            OptionCaption = 'Per Piece,Pre-Pack Item';
            OptionMembers = "Per Piece","Pre-Pack Item";
        }
        field(50040; "Multi-Parts"; Option)
        {
            Caption = 'Multi-Parts';
            DataClassification = ToBeClassified;
            Description = 'UPG';
            OptionCaption = 'Standard,Machine Stop,Expected Loss,Loss Item,Fix Inventory';
            OptionMembers = Standard,"M=Machine Stop","X=Expected Loss","Y=Loss Item","Z=Fix Inventory";
        }
        field(50050; "With MRAG Info."; Boolean)
        {
            Caption = 'With MRAG Info.';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(50060; "With MRJ Info."; Boolean)
        {
            Caption = 'With MRJ Info.';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(50070; "Is Enabled"; Boolean)
        {
            Caption = 'Is Enabled';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(50080; "Is New Entry"; Boolean)
        {
            Caption = 'Is New Entry';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(50090; "Shelf No. (Osaka)"; Code[10])
        {
            Caption = 'Shelf No. (Osaka)';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(50100; "Shelf No. (Niigata)"; Code[10])
        {
            Caption = 'Shelf No. (Niigata)';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(50110; "Shelf No. (Sendai)"; Code[10])
        {
            Caption = 'Shelf No. (Sendai)';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(50120; "Shelf No. (Fukuoka)"; Code[10])
        {
            Caption = 'Shelf No. (Fukuoka)';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(50130; "Shelf No. (Nagoya)"; Code[10])
        {
            Caption = 'Shelf No. (Nagoya)';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(50140; "New Shelf No."; Code[10])
        {
            Caption = 'New Shelf No.';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(50150; "Overseas/Domestic"; Option)
        {
            Caption = 'Overseas/Domestic';
            DataClassification = ToBeClassified;
            Description = 'UPG';
            OptionCaption = ' ,Overseas,Domestic';
            OptionMembers = " ",Overseas,Domestic;
        }
        field(90000; "FA Template Code"; Code[10])
        {
            Caption = 'FA Template Code';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
    }
}
