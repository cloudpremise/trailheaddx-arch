global class TrailheadDXFacebookRegHandler implements Auth.RegistrationHandler{
    global boolean canCreateUser(Auth.UserData data) {
		system.debug('canCreateUser');
        system.debug(data);
        return true;
    }

    global User createUser(Id portalId, Auth.UserData data){
        system.debug('createUser');
        system.debug( data );

        if(!canCreateUser(data)) {
            return null;
        }

        //Create a regular standard user
        User u = new User();
        Profile p = [SELECT Id FROM profile WHERE name='Standard User'];
        
        u.username = createGUID()  + '@trailheaddx-arch.com';
        u.email = data.email;
        u.lastName = data.lastName;
        u.firstName = data.firstName;
        
        String alias = data.lastName+'.'+data.firstName;
        
        //Alias must be 8 characters or less
        
        if(alias.length() > 8) {
            alias = alias.substring(0, 8);
        }
        
        u.alias = alias;
        u.languagelocalekey = UserInfo.getLocale();
        u.localesidkey = UserInfo.getLocale();
        u.emailEncodingKey = 'UTF-8';
        u.timeZoneSidKey = 'America/Los_Angeles';
        u.profileId = p.Id;
        
        return u;
    }

    global void updateUser(Id userId, Id portalId, Auth.UserData data){
        system.debug('updateUser');
        system.debug( data );
        
        User u = new User(id=userId);

        u.email = data.email;
        u.lastName = data.lastName;
        u.firstName = data.firstName;
        update(u);
    }

    public static String createGUID() {
        String kHexChars = '0123456789abcdef';
        String returnValue = '';
        Integer nextByte = 0;
        for (Integer i=0; i<16; i++) {
            if (i==4 || i==6 || i==8 || i==10) 
                returnValue += '-';
            nextByte = (Math.round(Math.random() * 255)-128) & 255;
            if (i==6) {
                nextByte = nextByte & 15;
                nextByte = nextByte | (4 << 4);
            }
            if (i==8) {
                nextByte = nextByte & 63;
                nextByte = nextByte | 128;
            }
            returnValue += getCharAtIndex(kHexChars, nextByte >> 4);
            returnValue += getCharAtIndex(kHexChars, nextByte & 15);
        }
        returnValue += '-' + UserInfo.getUserID();
        return returnValue;
    }
    private static String getCharAtIndex(String str, Integer index) {
        if (str == null) return null;
        if (str.length() <= 0) return str;    
        if (index == str.length()) return null;    
        return str.substring(index, index+1);
    }

}
