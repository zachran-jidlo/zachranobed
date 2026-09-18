# Accepted risks in firestore.rules

Security rules cannot look a pair up. A pair is stored under a generated
document id, and rules cannot run queries, so no rule can answer the question
"are these two entities paired". Everything below follows from that.

These are known and accepted. They are written down so the next reader does not
mistake them for an oversight.

## Meals can be read by any signed-in account

`match /meals/{mealId}` allows `get` to anyone who is signed in. A meal holds a
dish name, a food category, an allergen list and the id of the canteen.

The read cannot be narrowed, because a meal carries only the donor id and
nothing that ties it to a recipient. What limits access in practice is the
document id. It is a generated uuid, and the only place it appears is the meal
list of a delivery document, which already requires pair membership to read. So
in practice a meal is reachable by the two sides of the delivery it belongs to.

This holds only while the collection cannot be listed. `list` is off for that
reason. Anyone holding a Rowy role can still read and list the collection
through the generated block at the bottom of the rules file.

## Meals can be created with any donor id

`create` only checks that the caller carries an entity claim and that the donor
id is a string. Any account can write a meal document naming any canteen as the
donor.

The write cannot be tied back to the caller, because a charity recording a
manual donation legitimately writes meals whose donor is the canteen.

A meal created this way is not visible anywhere. Meals are only ever read by id,
and the only source of ids is a delivery document. A meal that no delivery
references is unreachable. Updates and deletes are off, so an existing meal
cannot be altered.

## Meal suggestions can be read by any entity

`match /entities/{entityId}/mealSuggestions/{suggestionId}` allows a read to any
account carrying an entity claim, whatever entity the subcollection belongs to.
A suggestion holds a dish name and an allergen list.

The only foreign read the app makes is the catalogue of the donor in the
caller's own active pair, which a charity needs when it records a manual
donation. Narrowing the rule to that would take a pair check.

Unlike the meals collection, `list` is on and has to stay on, because the name
autocomplete reads the whole catalogue. The path also carries the owner id as a
readable name rather than a generated one, so nothing here limits access the way
a generated document id does. Knowing another canteen's entity id is enough. The
ids cannot be listed out of the entities collection, but they are readable
strings and look guessable.

What it exposes is what one canteen offers, to another canteen. It is still
narrower than before, when any signed-in account could read it with no claim at
all.

## Both sides of a pair can write the whole shared pair state

`match /entityPairs/{pairId}` allows an update to either side of the pair and
limits it to the box counts and the checkup state. The limit is on top level
fields only.

The checkup is a map with one entry per side. A write addresses one entry by a
path built on the client, so nothing stops one side from addressing the other
side's entry. It can overwrite that entry whole, which drops the counts the
other side reported and changes the status the mismatch trigger reads.

The box counts are an array of maps, and the per box arithmetic is done on the
client. Rules cannot iterate an array, so the numbers cannot be validated at
all. They feed the monthly report.

This is accepted. The two entities in a pair work as one unit over shared
state, so one of them overwriting something the other wrote is a normal
outcome, not an attack.

## Deliveries can be created naming an arbitrary counterpart

`match /deliveries/{deliveryId}` allows `create` when the caller is one of the
two sides named in the new document. It does not check that the two sides are
paired, and it validates only the delivery date.

So an account can write a delivery document naming any other entity as its
counterpart, with any type, any state and any payload.

Two things act on such a document without checking the pair.

The first is `notifyCanteenAboutBoxShippmentV2`
(`functions/src/functions/notifications/boxReturnFunction.ts`). It fires on
every created delivery of the box type, reads the device tokens of the entity
named as the donor and sends it a push notification. A forged document
therefore delivers a push to any canteen.

The second is the monthly report (`buildReport` in
`functions/src/services/reportService.ts`). It selects deliveries by date, by
food delivery type and by completed state, with no pair condition, and buckets
the rows by donor and recipient. A forged document with those fields set lands
as a row in the report of the entity named as the counterpart, and that report
is sent out by email.

The sibling triggers are not affected. `boxDeliveryCreated` and `boxTransfer`
both load the pair and stop when there is none, and the remaining delivery
triggers run on update, which already requires pair membership. The delivery
history in the app queries by the donor and recipient of the active pair, so a
forged document does not appear there either.

## Either side of a pair can rewrite a whole delivery

`update` on a delivery pins the two sides and the delivery date. The rest of the
payload is not checked, so either side can rewrite the state, the meals, the box
list, the confirmation time, the pickup confirmation and the transfer flag.

The state is the part that reaches further than the document. It is a lifecycle
driven by the backend and by the carrier, and three Cloud Functions react to it.

Moving a delivery to the delivered state runs `boxTransfer`. Its only conditions
are the transition itself and the transfer flag being false, so one side can
start the box transfer at will. The counts it writes into the pair document come
from the box list on the delivery, which the same side can also rewrite.

Moving a delivery to the accepted or the not used state runs
`notifyCharityAboutDonationV2`, which sends a push to the recipient when the
pickup window is today.

Moving a food delivery to the done state puts it into the monthly report.
`buildReport` selects by date, by type and by that state, so the delivery
becomes a completed donation in a document that is sent out by email.

Nothing here reaches outside the pair. The rule still requires the caller to be
one of the two sides, so this is the same trade as the shared pair state above.
What it costs is the split of responsibility between the two sides. One of them
can change the numbers in the other one's record of donations and the shared box
balance, and nothing records who did it.

A hand written state also drifts from reality. The carrier order and the
scheduled transitions keep running, so the document can claim a delivery is done
while the courier is still on the way.
