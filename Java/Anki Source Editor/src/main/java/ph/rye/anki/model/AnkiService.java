/**
 *   Copyright 2016 Royce Remulla
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */
package ph.rye.anki.model;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import ph.rye.anki.AnkiMainGui;
import ph.rye.anki.util.StringUtil;

/**
 * @author royce
 *
 */
public class AnkiService {


    private static final String TAGS_MARKER = "@Tags: ";


    private transient boolean fileLoaded;


    private final transient TagModel tagModel = new TagModel();
    private final transient CardModel cardModel = new CardModel();
    private final transient TagModel cardTagModel = new TagModel();


    public void openFile(final File file) {

        cardModel.reset();
        tagModel.reset();

        try (BufferedReader buffReader =
                new BufferedReader(new FileReader(file))) {
            int spaceCounter = 0;
            boolean isAnswer = false;

            final List<String> front = new ArrayList<String>();
            final List<String> back = new ArrayList<String>();
            final List<String> tags = new ArrayList<String>();

            for (String line; (line = buffReader.readLine()) != null;) {
                if ("".equals(line.trim())) {
                    spaceCounter += 1;
                } else {

                    if (spaceCounter >= 2) {
                        isAnswer = false;

                        registerCard(front, back, tags);

                        front.clear();
                        back.clear();
                        tags.clear();
                    } else if (spaceCounter == 1) {
                        isAnswer = true;
                    }

                    if (!isAnswer) {

                        if (line.startsWith(TAGS_MARKER)) {
                            tags
                                .addAll(
                                    Arrays
                                        .asList(
                                            StringUtil
                                                .trimArray(
                                                    line
                                                        .substring(
                                                            TAGS_MARKER
                                                                .length())
                                                        .split(","))));
                        } else {
                            front.add(StringUtil.rtrim(line));
                        }
                    } else {
                        back.add(line);
                    }

                    spaceCounter = 0;
                }
            }
        } catch (final IOException ex) {
            Logger.getLogger(AnkiMainGui.class.getName()).log(
                Level.SEVERE,
                null,
                ex);
        }
        fileLoaded = true;

    }

    @SuppressWarnings("PMD.AvoidInstantiatingObjectsInLoops")
    public void registerCard(final List<String> front, final List<String> back,
                             final List<String> tags) {

        final Card newCard = new Card(
            StringUtil.join(front, "\n"),
            StringUtil.join(back, "\n"));

        newCard.addTags(tags.toArray(new String[tags.size()]));

        cardModel.addCard(newCard);

        for (final String tag : tags) {
            final Tag newTag = new Tag(tag, true);
            tagModel.addTag(newTag);
            cardTagModel.addTag(newTag);
        }
    }


    /**
     * @return the fileLoaded
     */
    public boolean isFileLoaded() {
        return fileLoaded;
    }

    /**
     * @param fileLoaded the fileLoaded to set
     */
    public void setFileLoaded(final boolean fileLoaded) {
        this.fileLoaded = fileLoaded;
    }

    /**
     * @return the tagModel
     */
    public TagModel getTagModel() {
        return tagModel;
    }

    /**
     * @return the cardModel
     */
    public CardModel getCardModel() {
        return cardModel;
    }

    /**
     * @return the cardTagModel
     */
    public TagModel getCardTagModel() {
        return cardTagModel;
    }

    /**
     * @param valueAt
     */
    public void initCardTagFromTag(final String valueAt) {
        cardTagModel.initWithTags(StringUtil.trimArray(valueAt.split(",")));
    }

    /** */
    public void updateCardTable(final int row, final int col) {
        final Card card = cardModel.getCardAt(row);
        card.setTags(cardTagModel.getSelectedTags());
        cardModel.fireTableCellUpdated(row, col);
    }


}
