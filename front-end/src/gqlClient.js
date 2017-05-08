import ApolloClient, { createNetworkInterface } from 'apollo-client';
import {SubscriptionClient, addGraphQLSubscriptions} from 'subscriptions-transport-ws';
import gql from 'graphql-tag';

const wsClient = new SubscriptionClient(`wss://subscriptions.graph.cool/v1/ciykpioqm1wl00120k2e8s4la`, {
  reconnect: true,
  connectionParams: {
    // Pass any arguments you want for initialization
  }
});

const networkInterface = createNetworkInterface({ uri: 'https://api.graph.cool/simple/v1/ciykpioqm1wl00120k2e8s4la' });

// Extend the network interface with the WebSocket
const networkInterfaceWithSubscriptions = addGraphQLSubscriptions(
  networkInterface,
  wsClient
);

const client = new ApolloClient({
  networkInterface: networkInterfaceWithSubscriptions
});

// Queries

const getAllProfiles = gql`
query {
  allBaseProfiles {
    id
    firstName
    avatar {
      url
    }
  }
}`;

const getUserProfile = gql`
query ($userId: ID) {
  User(id: $userId) {
    baseprofile {
      id
      firstName
      avatar {
        url
      }
    }
  }
}`;

const getUserSchedule = gql`
query ($userId: ID, $date: String) {
  allExtraScheduleItemses (
    filter: {
      extraschedule: {
        date: $date,
        user: {id: $userId}
      }
    }
  ) {
    name
    startTm
  }
}`;

// Mutations

const createUser = gql`
mutation ($firstName: String!) {
  createUser (
    baseprofile: {
      firstName: $firstName
    }
  ) {
    id
    baseprofile {
      firstName
    }
  }
}`;

const createScheduleGQL = gql`
mutation ($userId: ID!, $date: String!, $name: String!, $startTm: String!) {
  createExtraSchedule (
    userId: $userId,
    date: $date,
    extrascheduleitemses: {
      name: $name,
      startTm: $startTm
    }
  ) {
    id
  }
}`;

const addScheduleItemGQL = gql`
mutation ($scheduleId: ID,
          $name: String!,
          $category: EXTRA_SCHEDULE_ITEMS_CATEGORY,
          $startTm: String!,
          $endTm: String) {
  createExtraScheduleItems (extrascheduleId: $scheduleId,
                            name: $name,
                            category: $category,
                            startTm: $startTm,
                            endTm: $endTm) {
    id
    name
  }
}`;

const subscribeSchedule = gql`
subscription {
  ExtraScheduleItems {
    mutation
    node {
      name
      category
      startTm
      endTm
    }
  }
}`;

const clockinExtra = gql`
mutation ($id: ID!, $clockinTs: String) {
  updateTimecard(id: $id, clockinTs: $clockinTs) {
    id
    effectiveDt
    clockinTs
    clockoutTs
  }
}`;

const clockoutExtra = gql`
mutation ($id: ID!, $clockoutTs: String) {
  updateTimecard(id: $id, clockoutTs: $clockoutTs) {
    id
    effectiveDt
    clockinTs
    clockoutTs
  }
}`;

const getExtraInfoGQL = gql`
query ($email: String, $date: String) {
  allSkins(filter: {effectiveDt: $date}) {
    effectiveDt
    skinItems(filter: {email: $email}) {
      user {
        id
        baseprofile {
          firstName
          lastName
          avatar {
            url
          }
        }
        extraschedule(filter: {date: $date}) {
          id
          extrascheduleitemses(orderBy: startTm_ASC) {
            name
            category
            startTm
            endTm
          }
        }
        timecards(filter: {effectiveDt: $date}) {
          id
          effectiveDt
          clockinTs
          clockoutTs
        }
      }
      part
      pay
    }
  }
}
`;

const createTimecardGQL = gql`
mutation ($userId: ID!, $clockinTs: String, $clockoutTs: String, $effectiveDt: String!) {
  createTimecard(userId: $userId, clockinTs: $clockinTs, clockoutTs: $clockoutTs, effectiveDt: $effectiveDt) {
    id
    effectiveDt
  }
}`;

const paLiveMonitorAllExtraInfo = gql`
query ($date: String) {
  allSkins(filter: {effectiveDt: $date}) {
    effectiveDt
    skinItems {
      part
      pay
      user {
        id
        baseprofile {
          firstName
          lastName
          email
          avatar {
            url
          }
        }
        extraWardrobeStatuses {
          checkStatus
          files {
            url
          }
        }
        timecards(filter: {effectiveDt: $date}) {
          id
          effectiveDt
          clockinTs
          clockoutTs
        }
        extraschedule(filter: {date: $date}) {
          id
          extrascheduleitemses {
            name
            category
            startTm
            endTm
          }
        }
      }
    }
  }
}`;

const fetchDailySkinGQL = gql`
query ($date: String) {
  allSkins(filter: {effectiveDt: $date}) {
    skinItems {
      user {
        id
        baseprofile {
          firstName
          lastName
          avatar {
            url
          }
        }
      }
      part
      pay
      callStartTs
      email
    }
  }
}`;

const getAllWardrobeStatuses = gql`
{
  allExtraWardrobeStatuses {
    id
    checkStatus
    date
    files {
      id
      secret
      url
      name
    }
    user {
      id
      baseprofile {
        id
        firstName
        lastName
        avatar {
          id
          secret
          url
          name
        }
      }
    }
  }
}
`;

const updateWardrobeStatusFile = gql`
mutation ($statusId: ID!, $fileId: ID!) {
  addToExtraWardrobePic(extraWardrobeStatusExtraWardrobeStatusId: $statusId, filesFileId: $fileId) {
    extraWardrobeStatusExtraWardrobeStatus {
      id
      checkStatus
      date
      files {
        id
        secret
        url
        name
      }
      user {
        id
        baseprofile {
          firstName
          lastName
          avatar {
            id
            secret
            url
            name
          }
        }
      }
    }
  }
}`;

const updateUserAvatar = gql`
mutation updateUserAvatar($profileId: ID!, $fileId: ID!) {
  setProfileAvatar(avatarFileId: $fileId, baseProfileBaseProfileId: $profileId) {
    avatarFile {
      url
    }
  }
}`;

const checkOutWardrobe = gql`
mutation ($statusId: ID!) {
  updateExtraWardrobeStatus(id: $statusId, checkStatus: CHECKEDOUT) {
    id
    date
    checkStatus
    user {
      id
      baseprofile {
        firstName
        lastName
        avatar {
          id
          secret
          url
        }
      }
    }
    files {
      id
      secret
      url
    }
  }
}`;

const checkInWardrobe = gql`
mutation ($statusId: ID!) {
  updateExtraWardrobeStatus(id: $statusId, checkStatus: CHECKIN) {
    id
    date
    checkStatus
    user {
      id
      baseprofile {
        firstName
        lastName
        avatar {
          id
          secret
          url
        }
      }
    }
    files {
      id
      secret
      url
    }
  }
}`;

const uploadSkinGQL = gql`
mutation ($effectiveDt: String, $skinItems: [SkinskinItemsSkinItem!]) {
  createSkin(effectiveDt: $effectiveDt, skinItems: $skinItems) {
    id
    effectiveDt
    skinItems {
      id
      user {
        baseprofile {
          id
          firstName
          lastName
        }
      }
      callStartTs
      callEndTs
      pay
      part
      email
      firstName
      lastName
    }
  }
}`;

const createExtraGQL = gql`
mutation ($email: String!,
          $firstName: String!,
          $lastName: String!,
          $skinItemId: ID!) {
  createUser(employeeType: Extra,
             baseprofile: {
               firstName: $firstName,
               lastName: $lastName,
               email: $email
             },
             skinItemId: $skinItemId
  ) {
    id
  }
}`;

const createExtraWardrobeCardGQL = gql`
mutation ($userId: ID!, $date: String!) {
  createExtraWardrobeStatus(date: $date, userId: $userId, checkStatus: NOTCHECKEDOUT) {
    id
  }
}`;

export default {

  // subscriptions
  subExtraSchedule: function () {
    const query = subscribeSchedule;
    const variables = {};
    console.log(client);
    console.log(query);
    return client.query({ query, variables });
  },

  // Queries
  getAllExtraInfo: function (date) {
    const query = paLiveMonitorAllExtraInfo;
    console.log('QUERY!', query);
    const variables = {date};
    console.log(variables);
    return client.query({ query, variables });
  },

  clockoutExtra: function (id, clockoutTs) {
    const query = clockinExtra;
    const variables = { id, clockoutTs };
    console.log(query);
    console.log(variables);
    return client.mutate({ query, variables });
  },

  clockinExtra: function (id, clockinTs) {
    const mutation = clockinExtra;
    const variables = { id, clockinTs };
    return client.mutate({ mutation, variables });
  },

  fetchDailySkin: function (date) {
    const query = fetchDailySkinGQL;
    const variables = { date };
    return client.query({ query, variables });
  },

  getExtraInfo: function (email, date) {
    const query = getExtraInfoGQL;
    const variables = { email, date };
    return client.query({ query, variables });
  },

  getAllProfiles: function () {
    const query = getAllProfiles;
    return client.query({ query });
  },

  getUserProfile: function (userId) {
    const query = getUserProfile;
    const variables = { userId };
    return client.query({ query, variables });
  },

  getUserSchedule: function (userId, date) {
    const query = getUserSchedule;
    const variables = { userId, date };
    return client.query({ query, variables });
  },

  getAllWardrobeStatuses: function () {
    const query = getAllWardrobeStatuses;
    return client.query({ query });
  },

  // Mutations

  createTimecard: function (userId, clockinTs, clockoutTs, effectiveDt) {
    const mutation = createTimecardGQL;
    const variables = { userId, clockinTs, clockoutTs, effectiveDt };
    return client.mutate({ mutation, variables });
  },

  createExtra: function (email, firstName, lastName, skinItemId) {
    const mutation = createExtraGQL;
    const variables = { email, firstName, lastName, skinItemId };
    return client.mutate({ mutation, variables });
  },

  createUser: function (firstName) {
    const mutation = createUser;
    const variables = { firstName };
    return client.mutate({ mutation, variables });
  },

  updateUserAvatar: function (profileId, fileId) {
    const mutation = updateUserAvatar;
    const variables = { profileId, fileId };
    return client.mutate({ mutation, variables });
  },

  createSchedule: function (userId, date, name, startTm) {
    const mutation = createScheduleGQL;
    const variables = { userId, date, name, startTm };
    return client.mutate({ mutation, variables });
  },

  addScheduleItem: function (scheduleItem) {
    const mutation = addScheduleItemGQL;
    const {startTm, endTm, category, name} = scheduleItem;
    const variables = {scheduleId: 'cizbzpnmaw6m80148bpys69a6', startTm, endTm, category, name};
    return client.mutate({mutation, variables});
  },

  uploadSkin: function (effectiveDt, skinItems) {
    const mutation = uploadSkinGQL;
    console.log(mutation);
    const variables = {effectiveDt, skinItems};
    console.log(variables);
    return client.mutate({mutation, variables});
  },

  createExtraWardrobeCard: function (userId, date) {
    const mutation = createExtraWardrobeCardGQL;
    const variables = {userId, date};
    return client.mutate({mutation, variables});
  },

  updateWardrobeStatusFile: function (statusId, fileId) {
    const mutation = updateWardrobeStatusFile;
    const variables = { statusId, fileId };
    return client.mutate({mutation, variables});
  },
  checkOutWardrobe: function (statusId) {
    const mutation = checkOutWardrobe;
    const variables = { statusId };
    return client.mutate({ mutation, variables });
  },

  checkInWardrobe: function (statusId) {
    const mutation = checkInWardrobe;
    const variables = { statusId };
    return client.mutate({ mutation, variables });
  },


  // Non gql
  uploadSkinCSV: function(file){
    console.log(file);
  }
};
